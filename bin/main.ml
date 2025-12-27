open Core
module V = Raycast.Vec3
module R = Raycast.Ray
module VInfix = V.Infix
module World = Raycast.World
module Sphere = Raycast.Sphere
module Hittable = Raycast.Hittable
module Hit_record = Raycast.Hit_record
module Interval = Raycast.Interval

let () =
  let world =
    World.make
      [ Hittable.Sphere (Sphere.make (V.make 0. 0. (-1.)) 0.5)
      ; Hittable.Sphere (Sphere.make (V.make 0.4 0.34 (-1.)) 0.2)
      ; Hittable.Sphere (Sphere.make (V.make (-0.38) (-0.24) (-0.7)) 0.12)
      ; Hittable.Sphere (Sphere.make (V.make 0. (-100.5) (-1.)) 100.)
      ]
  in
  let camera = Raycast.Camera.make (16. /. 9.) 400 in
  Raycast.Camera.render camera world
;;
