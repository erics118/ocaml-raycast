(** hittable object in the scene *)
type t = Sphere of Sphere.t

(** checks if ray hits the object within the interval *)
val hit : t -> Ray.t -> Interval.t -> Hit_record.t option
