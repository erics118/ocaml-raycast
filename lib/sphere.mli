(** sphere with center and radius *)
type t =
  { center : Vec3.t
  ; radius : float
  }

(** creates a sphere *)
val make : Vec3.t -> float -> t

(** [hit sphere ray interval] tests if a ray hits this sphere within the given interval *)
val hit : t -> Ray.t -> Interval.t -> Hit_record.t option

(** [to_hittable sphere material] converts a sphere to a hittable with the given material
  *)
val to_hittable : t -> Material.t -> Hittable.t
