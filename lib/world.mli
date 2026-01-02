(** world containing a list of hittable objects *)
type t

(** creates a world from a list of hittable objects *)
val make : Hittable.t list -> t

(** [hit_world world ray interval] hits the closest hit in the world within the interval
  *)
val hit_world : t -> Ray.t -> Interval.t -> (Hit_record.t * Material.t) option
