let color_range = Interval.make 0. 1.

let component_to_intensity component =
  Int.of_float (255.999 *. Interval.clamp color_range component)
;;

let linear_to_gamma component =
  if Float.(component > 0.) then Float.sqrt component else 0.
;;

let write_color out c =
  let ir = c |> Vec3.x |> linear_to_gamma |> component_to_intensity in
  let ig = c |> Vec3.y |> linear_to_gamma |> component_to_intensity in
  let ib = c |> Vec3.z |> linear_to_gamma |> component_to_intensity in
  Out_channel.fprintf out "%d %d %d\n" ir ig ib
;;
