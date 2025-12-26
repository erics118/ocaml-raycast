type t

val make : Vec3.t -> float -> t
val hit : t -> Ray.t -> Interval.t -> Hit_record.t option
