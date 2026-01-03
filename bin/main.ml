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

let _basic_world =
  let material_ground = Material.make_lambertian (V.make 0.8 0.8 0.0) in
  let material_center = Material.make_lambertian (V.make 0.1 0.2 0.5) in
  let material_left = Material.make_dielectric 1.5 in
  let material_bubble = Material.make_dielectric (1.0 /. 1.5) in
  let material_right = Material.make_metal (V.make 0.8 0.6 0.2) 0.0 in
  World.make
    [ Sphere.to_hittable (Sphere.make (V.make 0. (-100.5) (-1.)) 100.) material_ground
    ; Sphere.to_hittable (Sphere.make (V.make 0. 0. (-1.2)) 0.5) material_center
    ; Sphere.to_hittable (Sphere.make (V.make (-1.) 0. (-1.)) 0.5) material_left
    ; Sphere.to_hittable (Sphere.make (V.make (-1.) 0. (-1.)) 0.4) material_bubble
    ; Sphere.to_hittable (Sphere.make (V.make 1. 0. (-1.)) 0.5) material_right
    ]
;;

let _wide_world =
  let r = Float.cos (Float.pi /. 4.) in
  let material_left = Material.make_lambertian (V.make 0. 0. 1.) in
  let material_right = Material.make_lambertian (V.make 1. 0. 0.) in
  World.make
    [ Sphere.to_hittable (Sphere.make (V.make (-.r) 0. (-1.)) r) material_left
    ; Sphere.to_hittable (Sphere.make (V.make r 0. (-1.)) r) material_right
    ]
;;

let random_color () = V.make (Random.float 1.) (Random.float 1.) (Random.float 1.)

let random_color_range lo hi =
  let range = hi -. lo in
  V.make (lo +. Random.float range) (lo +. Random.float range) (lo +. Random.float range)
;;

let final_world =
  let spheres = ref [] in
  let add_sphere m c r = spheres := Sphere.make_hittable c r m :: !spheres in
  (* ground *)
  let ground_material = Material.make_lambertian (V.make 0.5 0.5 0.5) in
  add_sphere ground_material (V.make 0. (-1000.) 0.) 1000.;
  (* random small spheres *)
  for a = -11 to 10 do
    for b = -11 to 10 do
      let center =
        V.make
          (Float.of_int a +. (0.9 *. Random.float 1.))
          0.2
          (Float.of_int b +. (0.9 *. Random.float 1.))
      in
      if Float.(V.norm V.(center -^ V.make 4. 0.2 0.) > 0.9)
      then (
        let sphere_material =
          match Random.float 1. with
          | x when Float.(x < 0.8) ->
            let albedo = V.(random_color () **^ random_color ()) in
            Material.make_lambertian albedo
          | x when Float.(x < 0.95) ->
            let albedo = random_color_range 0.5 1. in
            let fuzz = Random.float 0.5 in
            Material.make_metal albedo fuzz
          | _ -> Material.make_dielectric 1.5
        in
        add_sphere sphere_material center 0.2)
    done
  done;
  (* three large spheres *)
  let material1 = Material.make_dielectric 1.5 in
  let material2 = Material.make_lambertian (V.make 0.4 0.2 0.1) in
  let material3 = Material.make_metal (V.make 0.7 0.6 0.5) 0.0 in
  add_sphere material1 (V.make 0. 1. 0.) 1.0;
  add_sphere material2 (V.make (-4.) 1. 0.) 1.0;
  add_sphere material3 (V.make 4. 1. 0.) 1.0;
  World.make !spheres
;;

let () =
  let camera =
    Camera.make
      ~aspect_ratio:(16. /. 9.)
      ~image_width:1600
      ~samples_per_pixel:10
      ~max_depth:10
      ~vfov:20.
      ~lookfrom:(V.make 13. 2. 3.)
      ~lookat:(V.make 0. 0. 0.)
      ~vup:(V.make 0. 1. 0.)
      ~defocus_angle:0.6
      ~focus_dist:10.0
      ()
  in
  Camera.render camera final_world
;;
