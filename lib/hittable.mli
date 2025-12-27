(** hittable object in the scene *)
type hittable = Sphere of Sphere.t

(** checks if ray hits the object within the interval *)
val hit : hittable -> Ray.t -> Interval.t -> Hit_record.t option
