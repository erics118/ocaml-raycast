(** axis-aligned bounding box *)

type t

(** gets the x-axis interval *)
val x : t -> Interval.t

(** gets the y-axis interval *)
val y : t -> Interval.t

(** gets the z-axis interval *)
val z : t -> Interval.t

(** creates an empty aabb *)
val empty : t

(** creates an aabb from given axis intervals *)
val make : Interval.t -> Interval.t -> Interval.t -> t

(** creates an aabb that surrounds two points *)
val of_points : Vec3.t -> Vec3.t -> t

(** converts to list of intervals [x; y; z] *)
val to_list : t -> Interval.t list

(** returns the smallest AABB that contains both input boxes *)
val surrounding_box : t -> t -> t

(** tests if a ray hits the aabb within the given interval *)
val hit : t -> Ray.t -> Interval.t -> bool
