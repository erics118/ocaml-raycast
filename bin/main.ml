open Core
module V = Raycast.Vec3
module R = Raycast.Ray
module VInfix = V.Infix

let hit_sphere center radius r =
  let oc = VInfix.(R.origin r - center) in
  let a = V.norm2 (R.direction r) in
  let h = V.dot oc (R.direction r) in
  let c = V.norm2 oc -. (radius *. radius) in
  let discriminant = (h *. h) -. (a *. c) in
  if Float.(discriminant < 0.0) then -1.0
  else
    let sqrt_d = sqrt discriminant in
    let t1 = (-.h -. sqrt_d) /. a in
    let t2 = (-.h +. sqrt_d) /. a in
    if Float.(t1 > 0.0) then t1 else if Float.(t2 > 0.0) then t2 else -1.0

let ray_color r =
  let t = hit_sphere (V.make 0. 0. (-1.)) 0.5 r in
  if Float.(t > 0.0) then
    let n = VInfix.(V.normalize (R.at r t - V.make 0. 0. (-1.))) in
    V.scale 0.5 (V.make (V.x n +. 1.0) (V.y n +. 1.0) (V.z n +. 1.0))
  else
    let unit_direction = V.normalize (R.direction r) in
    let a = 0.5 *. (V.y unit_direction +. 1.0) in
    VInfix.(
      V.scale (1.0 -. a) (V.make 1.0 1.0 1.0) + V.scale a (V.make 0.5 0.7 1.0))

let () =
  let aspect_ratio = 16.0 /. 9.0 in
  let image_width = 400 in
  let image_height =
    max 1 (int_of_float (float_of_int image_width /. aspect_ratio))
  in

  let focal_length = 1.0 in
  let viewport_height = 2.0 in
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
      Raycast.Color.write_color stdout (ray_color ray)
    done
  done
