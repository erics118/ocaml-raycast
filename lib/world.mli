type t = { objects : Hittable.hittable list }

val make : Sphere.t list -> t
val hit_world : t -> Ray.t -> Interval.t -> Hit_record.t option
