module V = Vec3
open Vec3.Infix

let write_color out c =
  let scaled = 255.999 * c in
  let ir = int_of_float (V.x scaled)
  and ig = int_of_float (V.y scaled)
  and ib = int_of_float (V.z scaled) in
  Printf.fprintf out "%d %d %d\n" ir ig ib
