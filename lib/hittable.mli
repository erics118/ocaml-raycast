type hittable

val make_sphere : Sphere.t -> hittable
val hit : hittable -> Ray.t -> Interval.t -> Hit_record.t option
