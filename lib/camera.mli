type t =
  { aspect_ratio : float
  ; image_width : int
  ; image_height : int
  ; samples_per_pixel : int
  ; max_depth : int
  ; vfov : float
  ; lookfrom : Vec3.t
  ; lookat : Vec3.t
  ; vup : Vec3.t
  ; defocus_angle : float
  ; focus_dist : float
  ; center : Vec3.t
  ; pixel00_loc : Vec3.t
  ; pixel_delta_u : Vec3.t
  ; pixel_delta_v : Vec3.t
  ; u : Vec3.t
  ; v : Vec3.t
  ; w : Vec3.t
  ; defocus_disk_u : Vec3.t
  ; defocus_disk_v : Vec3.t
  }

(** make aspect_ratio image_width samples_per_pixel max_depth] creates a camera
  positioned at the origin, looking toward -Z, with a viewport height of 2 units.
  it has the given [aspect_ratio] and [image_width]. [image_height] is computed
    from these two values. [samples_per_pixel] is the number of samples to take per pixel
    when antialiasing. [max_depth] is the maximum recursion depth for ray bouncing
[make ?aspect_ratio ?image_width ?samples_per_pixel ?max_depth ?vfov ?lookfrom ?lookat ?vup ()]
    creates a camera with the given parameters.
    - [lookfrom]: camera position (default: origin)
    - [lookat]: point the camera looks at (default: (0, 0, -1))
    - [vup]: "up" direction for the camera (default: (0, 1, 0))
    - [vfov]: vertical field of view in degrees (default: 90)
  *)
val make
  :  ?aspect_ratio:float
  -> ?image_width:int
  -> ?samples_per_pixel:int
  -> ?max_depth:int
  -> ?vfov:float
  -> ?lookfrom:Vec3.t
  -> ?lookat:Vec3.t
  -> ?vup:Vec3.t
  -> ?defocus_angle:float
  -> ?focus_dist:float
  -> unit
  -> t

(** [render camera world] renders the given [world] to stdout using this camera *)
val render : t -> World.t -> unit
