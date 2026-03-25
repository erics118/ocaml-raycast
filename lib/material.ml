type t =
  | Lambertian of Vec3.t
  | Metal of Vec3.t * float
  | Dielectric of float

let make_lambertian albedo = Lambertian albedo

let make_metal albedo fuzz =
  (* clamp fuzz to [0, 1] *)
  Metal (albedo, Float.max 0. (Float.min fuzz 1.))
;;

let make_dielectric refractive_index = Dielectric refractive_index

let scatter_lambertian (albedo : Vec3.t) (r_in : Ray.t) (hr : Hit_record.t) =
  let scatter_direction = Vec3.(hr.normal +^ random_unit_vector ()) in
  (* catch degenerate scatter direction *)
  let scatter_direction =
    if Vec3.near_zero scatter_direction then hr.normal else scatter_direction
  in
  let scattered = Ray.make ~time:(Ray.time r_in) hr.p scatter_direction in
  Some (albedo, scattered)
;;

let scatter_metal
      (albedo : Vec3.t)
      (fuzz : float)
      (r_in : Ray.t)
      (hr : Hit_record.t)
  =
  let reflected_dir = Vec3.reflect (Ray.direction r_in) hr.normal in
  let reflected =
    Vec3.(normalize reflected_dir +^ (fuzz *^ random_unit_vector ()))
  in
  let scattered = Ray.make ~time:(Ray.time r_in) hr.p reflected in
  if Vec3.dot (Ray.direction scattered) hr.normal > 0.
  then Some (albedo, scattered)
  else None
;;

let scatter_dielectric
      (refractive_index : float)
      (r_in : Ray.t)
      (hr : Hit_record.t)
  =
  let reflectance cos_theta ref_idx =
    (* using Schlick's approximation for reflectance. *)
    let r0 = ((1. -. ref_idx) /. (1. +. ref_idx)) ** 2. in
    r0 +. ((1. -. r0) *. ((1. -. cos_theta) ** 5.))
  in
  let attenuation = Vec3.make 1. 1. 1. in
  let ri =
    if hr.front_face then 1.0 /. refractive_index else refractive_index
  in
  let unit_direction = Vec3.normalize (Ray.direction r_in) in
  let cos_theta = Float.min (Vec3.dot (Vec3.neg unit_direction) hr.normal) 1. in
  let sin_theta = Float.sqrt (1. -. (cos_theta *. cos_theta)) in
  let direction =
    if ri *. sin_theta > 1.0 || reflectance cos_theta ri > Random.float 1.
    then Vec3.reflect unit_direction hr.normal
    else Vec3.refract unit_direction hr.normal ri
  in
  let scattered = Ray.make ~time:(Ray.time r_in) hr.p direction in
  Some (attenuation, scattered)
;;

let scatter mat r_in hr =
  match mat with
  | Lambertian albedo -> scatter_lambertian albedo r_in hr
  | Metal (albedo, fuzz) -> scatter_metal albedo fuzz r_in hr
  | Dielectric refractive_index -> scatter_dielectric refractive_index r_in hr
;;
