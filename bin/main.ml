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
  let material_ground = Material.make_lambertian (V.make 0.8 0.8 0.0) in
  let material_center = Material.make_lambertian (V.make 0.1 0.2 0.5) in
  let material_left = Material.make_dielectric 1.5 in
  let material_bubble = Material.make_dielectric (1.0 /. 1.5) in
  let material_right = Material.make_metal (V.make 0.8 0.6 0.2) 0.0 in
  let world =
    World.make
      [ Sphere.to_hittable (Sphere.make (V.make 0. 0. (-1.2)) 0.5) material_center
      ; Sphere.to_hittable (Sphere.make (V.make (-1.) 0. (-1.)) 0.5) material_left
      ; Sphere.to_hittable (Sphere.make (V.make (-1.) 0. (-1.)) 0.4) material_bubble
      ; Sphere.to_hittable (Sphere.make (V.make 1. 0. (-1.)) 0.5) material_right
      ; Sphere.to_hittable (Sphere.make (V.make 0. (-100.5) (-1.)) 100.) material_ground
      ]
  in
  let camera =
    Camera.make
      ~aspect_ratio:(16. /. 9.)
      ~image_width:400
      ~samples_per_pixel:10
      ~max_depth:10
  in
  Camera.render camera world
;;
