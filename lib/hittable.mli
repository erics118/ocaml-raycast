(** A hittable object in the scene *)
type t = { hit : Ray.t -> Interval.t -> (Hit_record.t * Material.t) option }
