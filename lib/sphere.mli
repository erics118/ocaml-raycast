(** sphere with center and radius *)
type t =
  { center : Ray.t
  ; radius : float
  }

(** creates a sphere *)
val make : Vec3.t -> float -> t

(** creates a moving sphere with center moving from [center] to [center2] over
  time [0,1] *)
val make_moving : Vec3.t -> Vec3.t -> float -> t

(** [hit sphere ray interval] tests if a ray hits this sphere within the given
  interval *)
val hit : t -> Ray.t -> Interval.t -> Hit_record.t option

(** compute the bounding box for a sphere.
    For moving spheres, returns a box that contains the sphere at all times 0-1. *)
val bounding_box : t -> Aabb.t

(** [to_hittable sphere material] converts a sphere to a hittable with the given
  material *)
val to_hittable : t -> Material.t -> Hittable.t
