type t
(** world containing a list of hittable objects *)

val make : Hittable.hittable list -> t
(** creates a world from a list of hittable objects *)

val hit_world : t -> Ray.t -> Interval.t -> Hit_record.t option
(** finds the closest hit in the world within the interval *)
