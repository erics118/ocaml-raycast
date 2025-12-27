(** sphere with center and radius *)
type t

(** creates a sphere *)
val make : Vec3.t -> float -> t

(** checks if ray hits the sphere within the interval *)
val hit : t -> Ray.t -> Interval.t -> Hit_record.t option
