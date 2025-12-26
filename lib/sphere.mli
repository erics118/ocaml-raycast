type t
(** sphere with center and radius *)

val make : Vec3.t -> float -> t
(** creates a sphere *)

val hit : t -> Ray.t -> Interval.t -> Hit_record.t option
(** checks if ray hits the sphere within the interval *)
