module V = Vec3

let color_range = Interval.make 0. 1.

let component_to_intensity component =
  int_of_float (255.999 *. Interval.clamp color_range component)
;;

let linear_to_gamma component = if component > 0. then sqrt component else 0.

let write_color out c =
  let ir = c |> V.x |> linear_to_gamma |> component_to_intensity in
  let ig = c |> V.y |> linear_to_gamma |> component_to_intensity in
  let ib = c |> V.z |> linear_to_gamma |> component_to_intensity in
  Printf.fprintf out "%d %d %d\n" ir ig ib
;;
