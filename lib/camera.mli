type t =
  { aspect_ratio : float
  ; image_width : int
  ; image_height : int
  ; samples_per_pixel : int
  ; max_depth : int
  ; center : Vec3.t
  ; pixel00_loc : Vec3.t
  ; pixel_delta_u : Vec3.t
  ; pixel_delta_v : Vec3.t
  }

(** [make aspect_ratio image_width samples_per_pixel max_depth] creates a camera
  positioned at the origin, looking toward -Z, with a viewport height of 2 units.
  it has the given [aspect_ratio] and [image_width]. [image_height] is computed
  from these two values.
  [samples_per_pixel] is the number of samples to take per pixel when antialiasing.
  [max_depth] is the maximum recursion depth for ray bouncing
  *)
val make
  :  aspect_ratio:float
  -> image_width:int
  -> samples_per_pixel:int
  -> max_depth:int
  -> t

(** [render camera world] renders the given [world] to stdout using this camera *)
val render : t -> World.t -> unit
