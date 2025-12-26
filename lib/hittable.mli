(** hittable object in the scene *)
type hittable = Sphere of Sphere.t

val hit : hittable -> Ray.t -> Interval.t -> Hit_record.t option
(** checks if ray hits the object within the interval *)
