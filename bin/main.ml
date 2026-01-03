open Core
module V = Raytracer.Vec3
module R = Raytracer.Ray
module Camera = Raytracer.Camera
module World = Raytracer.World
module Sphere = Raytracer.Sphere
module Material = Raytracer.Material
module Hittable = Raytracer.Hittable
module Hit_record = Raytracer.Hit_record
module Interval = Raytracer.Interval

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
    Camera.make
      ~aspect_ratio:(16. /. 9.)
      ~image_width:6400
      ~samples_per_pixel:10
      ~max_depth:10
  in
  Camera.render camera world
;;
