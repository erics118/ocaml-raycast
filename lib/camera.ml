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

let degrees_to_radians degrees = degrees *. Float.pi /. 180.

let make
      ?(aspect_ratio = 1.)
      ?(image_width = 100)
      ?(samples_per_pixel = 10)
      ?(max_depth = 10)
      ?(vfov = 90.)
      ?(lookfrom = Vec3.zero)
      ?(lookat = Vec3.make 0. 0. (-1.))
      ?(vup = Vec3.make 0. 1. 0.)
      ?(defocus_angle = 0.)
      ?(focus_dist = 10.)
      ()
  =
  let image_height =
    max 1 (int_of_float (float_of_int image_width /. aspect_ratio))
  in
  let theta = degrees_to_radians vfov in
  let h = tan (theta /. 2.) in
  let viewport_height = 2. *. h *. focus_dist in
  let viewport_width =
    float_of_int image_width /. float_of_int image_height *. viewport_height
  in
  let w = Vec3.normalize Vec3.(lookfrom -^ lookat) in
  let u = Vec3.normalize (Vec3.cross vup w) in
  let v = Vec3.cross w u in
  let camera_center = lookfrom in
  let viewport_u = Vec3.(viewport_width *^ u) in
  let viewport_v = Vec3.(-.viewport_height *^ v) in
  let pixel_delta_u = Vec3.(viewport_u /^ float_of_int image_width) in
  let pixel_delta_v = Vec3.(viewport_v /^ float_of_int image_height) in
  let viewport_upper_left =
    Vec3.(
      camera_center
      -^ (focus_dist *^ w)
      -^ (viewport_u /^ 2.)
      -^ (viewport_v /^ 2.))
  in
  let pixel00_loc =
    Vec3.(viewport_upper_left +^ (pixel_delta_u /^ 2.) +^ (pixel_delta_v /^ 2.))
  in
  let defocus_radius =
    focus_dist *. tan (degrees_to_radians (defocus_angle /. 2.))
  in
  { aspect_ratio
  ; image_width
  ; image_height
  ; max_depth
  ; vfov
  ; lookfrom
  ; lookat
  ; vup
  ; defocus_angle
  ; focus_dist
  ; samples_per_pixel
  ; center = camera_center
  ; pixel00_loc
  ; pixel_delta_u
  ; pixel_delta_v
  ; u
  ; v
  ; w
  ; defocus_disk_u = Vec3.(defocus_radius *^ u)
  ; defocus_disk_v = Vec3.(defocus_radius *^ v)
  }
;;

(** returns a point in the square -0.5 to 0.5 in x and y directions *)
let sample_square () =
  let r1 = Random.float 1. -. 0.5 in
  let r2 = Random.float 1. -. 0.5 in
  Vec3.make r1 r2 0.
;;

let random_in_unit_disk () =
  let rec aux () =
    let p = Vec3.make (Random.float 2. -. 1.) (Random.float 2. -. 1.) 0. in
    if Vec3.dot p p >= 1. then aux () else p
  in
  aux ()
;;

let defocus_disk_sample (camera : t) =
  let p = random_in_unit_disk () in
  Vec3.(
    camera.center
    +^ (x p *^ camera.defocus_disk_u)
    +^ (y p *^ camera.defocus_disk_v))
;;

(** [get_ray camera i j] constructs a camera ray that is slightly randomized for
  antialiasing purposes *)
let get_ray camera i j =
  let offset = sample_square () in
  let pixel_sample =
    Vec3.(
      camera.pixel00_loc
      +^ ((float_of_int i +. Vec3.x offset) *^ camera.pixel_delta_u)
      +^ ((float_of_int j +. Vec3.y offset) *^ camera.pixel_delta_v))
  in
  let ray_origin =
    if camera.defocus_angle <= 0.
    then camera.center
    else defocus_disk_sample camera
  in
  let ray_direction = Vec3.(pixel_sample -^ ray_origin) in
  let time = Random.float 1. in
  Ray.make ~time ray_origin ray_direction
;;

(** [ray_color ray world depth] computes the color seen along [ray] in [world]
 * with recursion depth limit [depth] *)
let rec ray_color r world depth =
  if depth <= 0
  then Vec3.zero
  else (
    match World.hit_world world r (Interval.make 0.001 Float.infinity) with
    | Some (hr, mat) ->
      (match mat.Material.scatter r hr with
       | Some (attenuation, scattered) ->
         Vec3.(attenuation **^ ray_color scattered world (depth - 1))
       | None -> Vec3.zero)
    | None ->
      (* background color *)
      Vec3.make 1. 1. 1.)
;;

let render camera world =
  Printf.printf "P3\n%d %d\n255\n" camera.image_width camera.image_height;
  for j = 0 to camera.image_height - 1 do
    for i = 0 to camera.image_width - 1 do
      let pixel_color_sum = ref Vec3.zero in
      for _s = 0 to camera.samples_per_pixel - 1 do
        let ray = get_ray camera i j in
        let color = ray_color ray world camera.max_depth in
        pixel_color_sum := Vec3.(!pixel_color_sum +^ color)
      done;
      let pixel_color =
        Vec3.(!pixel_color_sum /^ float_of_int camera.samples_per_pixel)
      in
      Color.write_color stdout pixel_color
    done
  done
;;
