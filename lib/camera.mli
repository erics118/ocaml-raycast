type t =
  { aspect_ratio : float
  ; image_width : int
  ; image_height : int
  ; center : Vec3.t
  ; pixel00_loc : Vec3.t
  ; pixel_delta_u : Vec3.t
  ; pixel_delta_v : Vec3.t
  }

(** [make aspect_ratio image_width] creates a camera with the given
    [aspect_ratio] and [image_width]. The camera is positioned at the origin,
    looking toward -Z, with a viewport height of 2 units *)
val make : float -> int -> t

(** [render camera world] renders the given [world] to stdout using this camera *)
val render : t -> World.t -> unit
