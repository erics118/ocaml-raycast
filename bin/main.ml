open Core
module V = Raycast.Vec3
module R = Raycast.Ray
module VInfix = V.Infix
module World = Raycast.World
module Sphere = Raycast.Sphere
module Hittable = Raycast.Hittable
module Hit_record = Raycast.Hit_record
module Interval = Raycast.Interval

let ray_color r world =
  match World.hit_world world r (Interval.make 0. Float.infinity) with
  | Some hr ->
      let n = hr.normal in
      V.scale 0.5 (V.make (V.x n +. 1.) (V.y n +. 1.) (V.z n +. 1.))
  | None ->
      let unit_direction = V.normalize (R.direction r) in
      let a = 0.5 *. (V.y unit_direction +. 1.) in
      VInfix.(
        V.scale (1. -. a) (V.make 1. 1. 1.) + V.scale a (V.make 0.5 0.7 1.))

let () =
  let aspect_ratio = 16. /. 9. in
  let image_width = 1600 in
  let image_height =
    max 1 (int_of_float (float_of_int image_width /. aspect_ratio))
  in

  let focal_length = 1. in
  let viewport_height = 2. in
  let viewport_width =
    float_of_int image_width /. float_of_int image_height *. viewport_height
  in

  let camera_center = V.zero in

  let viewport_u = V.make viewport_width 0. 0. in
  let viewport_v = V.make 0. (-.viewport_height) 0. in

  let pixel_delta_u =
    viewport_u |> fun v -> V.div v (float_of_int image_width)
  in
  let pixel_delta_v =
    viewport_v |> fun v -> V.div v (float_of_int image_height)
  in

  let viewport_upper_left =
    VInfix.(
      camera_center - V.make 0. 0. focal_length - V.div viewport_u 2.
      - V.div viewport_v 2.)
  in

  let pixel00_loc =
    VInfix.(
      viewport_upper_left - V.div pixel_delta_u 2. - V.div pixel_delta_v 2.)
  in

  let world =
    World.make
      [
        Sphere.make (V.make 0. 0. (-1.)) 0.5;
        Sphere.make (V.make 0.4 0.34 (-1.)) 0.2;
        Sphere.make (V.make (-0.38) (-0.24) (-0.7)) 0.12;
        Sphere.make (V.make 0. (-100.5) (-1.)) 100.;
      ]
  in

  Printf.printf "P3\n%d %d\n255\n" image_width image_height;

  for j = 0 to image_height - 1 do
    for i = 0 to image_width - 1 do
      let pixel_center =
        VInfix.(
          pixel00_loc
          + V.scale (float_of_int i) pixel_delta_u
          + V.scale (float_of_int j) pixel_delta_v)
      in
      let direction = VInfix.(pixel_center - camera_center) in
      let ray = R.make camera_center direction in
      Raycast.Color.write_color stdout (ray_color ray world)
    done
  done
