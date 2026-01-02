type t = { scatter : Ray.t -> Hit_record.t -> (Vec3.t * Ray.t) option }

let make_lambertian albedo =
  { scatter =
      (fun _r_in hr ->
        let scatter_direction = Vec3.(hr.normal +^ random_unit_vector ()) in
        (* catch degenerate scatter direction *)
        let scatter_direction =
          if Vec3.near_zero scatter_direction then hr.normal else scatter_direction
        in
        let scattered = Ray.make hr.p scatter_direction in
        Some (albedo, scattered))
  }
;;

let make_metal albedo fuzz =
  (* clamp fuzz to [0, 1] *)
  let fuzz = Float.max 0. (Float.min fuzz 1.) in
  { scatter =
      (fun r_in hr ->
        let reflected = Vec3.reflect (Ray.direction r_in) hr.normal in
        let reflected = Vec3.(normalize reflected +^ (fuzz *^ random_unit_vector ())) in
        let scattered = Ray.make hr.p reflected in
        if Vec3.dot (Ray.direction scattered) hr.normal > 0.
        then Some (albedo, scattered)
        else None)
  }
;;
