module V = Vec3

let color_range = Interval.make 0. 1.

let component_to_intensity component =
  int_of_float (255.999 *. Interval.clamp color_range component)
;;

let write_color out c =
  let ir = component_to_intensity (V.x c)
  and ig = component_to_intensity (V.y c)
  and ib = component_to_intensity (V.z c) in
  Printf.fprintf out "%d %d %d\n" ir ig ib
;;
