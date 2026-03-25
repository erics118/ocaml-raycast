(** material determines how rays scatter off a surface *)
type t =
  | Lambertian of Vec3.t
  | Metal of Vec3.t * float
  | Dielectric of float

(** [make_lambertian albedo] creates a lambertian material with the given albedo color *)
val make_lambertian : Vec3.t -> t

(** [make_metal albedo fuzz] creates a metal material with the given albedo color and fuzziness *)
val make_metal : Vec3.t -> float -> t

(** [make_dielectric refractive_index] creates a dielectric material with the given refractive index *)
val make_dielectric : float -> t

(** [scatter mat r_in hr] returns the attenuation color and scattered ray, or None if absorbed *)
val scatter : t -> Ray.t -> Hit_record.t -> (Vec3.t * Ray.t) option
