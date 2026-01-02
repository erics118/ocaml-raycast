open Core
module V = Raycast.Vec3
module R = Raycast.Ray
module World = Raycast.World
module Sphere = Raycast.Sphere
module Material = Raycast.Material
module Hittable = Raycast.Hittable
module Hit_record = Raycast.Hit_record
module Interval = Raycast.Interval

let () =
  let mat_ground = Material.make_lambertian (V.make 0.8 0.8 0.0) in
  let mat_center = Material.make_lambertian (V.make 0.7 0.3 0.3) in
  let mat_left = Material.make_metal (V.make 0.8 0.8 0.8) 0.1 in
  let mat_right = Material.make_metal (V.make 0.8 0.7 0.6) 0.6 in
  let world =
    World.make
      [ Sphere.to_hittable (Sphere.make (V.make 0. 0. (-1.)) 0.5) mat_center
      ; Sphere.to_hittable (Sphere.make (V.make 0.4 0.34 (-0.6)) 0.1) mat_right
      ; Sphere.to_hittable (Sphere.make (V.make (-1.) (-0.24) (-0.8)) 0.5) mat_left
      ; Sphere.to_hittable (Sphere.make (V.make 0. (-100.5) (-1.)) 100.) mat_ground
      ]
  in
  let camera =
    Raycast.Camera.make
      ~aspect_ratio:(16. /. 9.)
      ~image_width:400
      ~samples_per_pixel:10
      ~max_depth:10
  in
  Raycast.Camera.render camera world
;;
