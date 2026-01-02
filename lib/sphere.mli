(** sphere with center and radius *)
type t =
  { center : Vec3.t
  ; radius : float
  }

(** creates a sphere *)
val make : Vec3.t -> float -> t

(** test if a ray hits this sphere within the given interval *)
val hit : t -> Ray.t -> Interval.t -> Hit_record.t option

(** convert sphere to a hittable for use in world *)
val to_hittable : t -> Hittable.t
