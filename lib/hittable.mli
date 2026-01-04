(** a hittable object in the scene *)
type t =
  { hit : Ray.t -> Interval.t -> (Hit_record.t * Material.t) option
  ; bounding_box : Aabb.t
  }
