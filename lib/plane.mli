(** a bounded rectangular plane (quad) defined by center, normal, and dimensions *)
type t =
  { center : Vec3.t (** center point of the rectangle *)
  ; normal : Vec3.t (** normal vector (normalized) *)
  ; u : Vec3.t (** local x-axis vector (half-width in this direction) *)
  ; v : Vec3.t (** local y-axis vector (half-length in this direction) *)
  ; width : float (** full width *)
  ; length : float (** full length *)
  }

(** [make center normal width length] creates a bounded rectangular plane,
    centered at [center] with the given [normal]. [width] and [length] define
    the dimensions. *)
val make : Vec3.t -> Vec3.t -> float -> float -> t

val hit : t -> Ray.t -> Interval.t -> Hit_record.t option
val to_hittable : t -> Material.t -> Hittable.t

val make_hittable
  :  Vec3.t
  -> Vec3.t
  -> float
  -> float
  -> Material.t
  -> Hittable.t
