(** bounding volume hierarchy for accelerated ray-scene intersection *)
type t

(** build a BVH from a list of hittables *)
val of_list : Hittable.t list -> t

(** get the bounding box of a BVH *)
val bounding_box : t -> Aabb.t

(** tests if a ray hits anything in the BVH *)
val hit : t -> Ray.t -> Interval.t -> (Hit_record.t * Material.t) option

(** converts a BVH to a hittable *)
val to_hittable : t -> Hittable.t

(** builds a BVH from a list of hittables and return as a hittable *)
val make : Hittable.t list -> Hittable.t
