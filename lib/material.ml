type t = { scatter : Ray.t -> Hit_record.t -> (Vec3.t * Ray.t) option }

let make_lambertian albedo =
  { scatter =
      (fun _r_in hr ->
        let scatter_direction = Vec3.(hr.normal +^ random_unit_vector ()) in
        (* catch degenerate scatter direction *)
        let scatter_direction =
          if Vec3.near_zero scatter_direction
          then hr.normal
          else scatter_direction
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
        let reflected =
          Vec3.(normalize reflected +^ (fuzz *^ random_unit_vector ()))
        in
        let scattered = Ray.make hr.p reflected in
        if Vec3.dot (Ray.direction scattered) hr.normal > 0.
        then Some (albedo, scattered)
        else None)
  }
;;

let make_dielectric refractive_index =
  let reflectance cos_theta ref_idx =
    (* using Schlick's approximation for reflectance. *)
    let r0 = ((1. -. ref_idx) /. (1. +. ref_idx)) ** 2. in
    r0 +. ((1. -. r0) *. ((1. -. cos_theta) ** 5.))
  in
  { scatter =
      (fun r_in hr ->
        let attenuation = Vec3.make 1. 1. 1. in
        let ri =
          if hr.front_face then 1.0 /. refractive_index else refractive_index
        in
        let unit_direction = Vec3.normalize (Ray.direction r_in) in
        let cos_theta =
          Float.min (Vec3.dot (Vec3.neg unit_direction) hr.normal) 1.
        in
        let sin_theta = Float.sqrt (1. -. (cos_theta *. cos_theta)) in
        let direction =
          if ri *. sin_theta > 1.0 || reflectance cos_theta ri > Random.float 1.
          then Vec3.reflect unit_direction hr.normal
          else Vec3.refract unit_direction hr.normal ri
        in
        let scattered = Ray.make hr.p direction in
        Some (attenuation, scattered))
  }
;;
