module V = Vec3
module VInfix = Vec3.Infix

type t =
  { aspect_ratio : float
  ; image_width : int
  ; image_height : int
  ; samples_per_pixel : int
  ; center : Vec3.t
  ; pixel00_loc : Vec3.t
  ; pixel_delta_u : Vec3.t
  ; pixel_delta_v : Vec3.t
  }

let make aspect_ratio image_width samples_per_pixel =
  let image_height = max 1 (int_of_float (float_of_int image_width /. aspect_ratio)) in
  let focal_length = 1. in
  let viewport_height = 2. in
  let viewport_width =
    float_of_int image_width /. float_of_int image_height *. viewport_height
  in
  let camera_center = V.zero in
  let viewport_u = V.make viewport_width 0. 0. in
  let viewport_v = V.make 0. (-.viewport_height) 0. in
  let pixel_delta_u = VInfix.(viewport_u / float_of_int image_width) in
  let pixel_delta_v = VInfix.(viewport_v / float_of_int image_height) in
  let viewport_upper_left =
    VInfix.(
      camera_center - V.make 0. 0. focal_length - (viewport_u / 2.) - (viewport_v / 2.))
  in
  let pixel00_loc =
    VInfix.(viewport_upper_left - (pixel_delta_u / 2.) - (pixel_delta_v / 2.))
  in
  { aspect_ratio
  ; image_width
  ; image_height
  ; samples_per_pixel
  ; center = camera_center
  ; pixel00_loc
  ; pixel_delta_u
  ; pixel_delta_v
  }
;;

(** returns a point in the square -0.5 to 0.5 in x and y directions *)
let sample_square () : Vec3.t =
  let r1 = Random.float 1. -. 0.5 in
  let r2 = Random.float 1. -. 0.5 in
  Vec3.make r1 r2 0.
;;

(** [get_ray camera i j] constructs a camera ray that is slightly randomized for
  antialiasing purposes *)
let get_ray (camera : t) (i : int) (j : int) : Ray.t =
  let offset = sample_square () in
  let direction =
    VInfix.(
      camera.pixel00_loc
      + ((float_of_int i +. V.x offset) * camera.pixel_delta_u)
      + ((float_of_int j +. V.y offset) * camera.pixel_delta_v))
  in
  Ray.make camera.center VInfix.(direction - camera.center)
;;

(** [ray_color ray world] computes the color seen along [ray] in [world] *)
let ray_color (r : Ray.t) (world : World.t) =
  match World.hit_world world r (Interval.make 0. Float.infinity) with
  | Some hr ->
    let n = hr.normal in
    VInfix.(0.5 * (n + V.make 1. 1. 1.))
  | None ->
    let unit_direction = V.normalize (Ray.direction r) in
    let a = 0.5 *. (V.y unit_direction +. 1.) in
    VInfix.(((1. -. a) * V.make 1. 1. 1.) + (a * V.make 0.5 0.7 1.))
;;

let render camera world =
  Printf.printf "P3\n%d %d\n255\n" camera.image_width camera.image_height;
  for j = 0 to camera.image_height - 1 do
    for i = 0 to camera.image_width - 1 do
      let pixel_color = ref (V.make 0. 0. 0.) in
      for s = 0 to camera.samples_per_pixel - 1 do
        let ray = get_ray camera i j in
        let sample_color = ray_color ray world in
        VInfix.(pixel_color := !pixel_color + sample_color)
      done
      [@warning "-35"];
      Color.write_color
        stdout
        VInfix.(!pixel_color / float_of_int camera.samples_per_pixel)
    done
  done
;;
