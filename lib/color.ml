module V = Vec3

let component_to_intensity component =
  let interval = Interval.make 0. 1. in
  int_of_float (255.999 *. Interval.clamp interval component)
;;

let write_color out c =
  let ir = component_to_intensity (V.x c)
  and ig = component_to_intensity (V.y c)
  and ib = component_to_intensity (V.z c) in
  Printf.fprintf out "%d %d %d\n" ir ig ib
;;
