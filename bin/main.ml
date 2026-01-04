open Core
module Vec3 = Raytracer.Vec3
module Camera = Raytracer.Camera
module World = Raytracer.World
module Sphere = Raytracer.Sphere
module Plane = Raytracer.Plane
module Material = Raytracer.Material
module Bvh = Raytracer.Bvh

let basic_world () =
  let objects = ref [] in
  let add obj = objects := obj :: !objects in
  let add_sphere s mat = add (Sphere.to_hittable s mat) in
  let add_plane center normal w l mat =
    add (Plane.make_hittable center normal w l mat)
  in
  let green = Material.make_lambertian (Vec3.make 0.0 0.8 0.0) in
  let blue = Material.make_lambertian (Vec3.make 0.1 0.2 0.5) in
  let red = Material.make_lambertian (Vec3.make 0.8 0.1 0.0) in
  let glass = Material.make_dielectric 2. in
  let metal = Material.make_metal (Vec3.make 0.8 0.6 0.2) 0.0 in
  add_sphere (Sphere.make (Vec3.make (-1.) 7. (-4.)) 3.) red;
  add_sphere (Sphere.make (Vec3.make (-3.) 3. 3.) 5.) metal;
  add_sphere (Sphere.make (Vec3.make 3. 0. (-5.)) 4.) glass;
  add_sphere (Sphere.make (Vec3.make 3. 1. 0.) 2.) red;
  add_sphere (Sphere.make (Vec3.make 4. 3. 6.) 2.) blue;
  add_plane Vec3.zero (Vec3.make 0. 1. 0.) 20. 20. green;
  let world = World.make !objects in
  let camera =
    Camera.make
      ~aspect_ratio:(16. /. 9.)
      ~image_width:1600
      ~samples_per_pixel:20
      ~max_depth:50
      ~vfov:50.
      ~lookfrom:(Vec3.make 25. 25. 6.)
      ~lookat:(Vec3.make 0. 0. 0.)
      ~vup:(Vec3.make 0. 1. 0.)
      ()
  in
  Camera.render camera world
;;

let random_color () =
  Vec3.make (Random.float 1.) (Random.float 1.) (Random.float 1.)
;;

let random_color_range lo hi =
  let range = hi -. lo in
  Vec3.make
    (lo +. Random.float range)
    (lo +. Random.float range)
    (lo +. Random.float range)
;;

let final_world () =
  let spheres = ref [] in
  let add m s = spheres := Sphere.to_hittable s m :: !spheres in
  (* ground *)
  let ground_material = Material.make_lambertian (Vec3.make 0.5 0.5 0.5) in
  add ground_material (Sphere.make (Vec3.make 0. (-1000.) 0.) 1000.);
  (* random small spheres *)
  for a = -11 to 10 do
    for b = -11 to 10 do
      let center =
        Vec3.make
          (Float.of_int a +. (0.9 *. Random.float 1.))
          0.2
          (Float.of_int b +. (0.9 *. Random.float 1.))
      in
      if Float.(Vec3.norm Vec3.(center -^ Vec3.make 4. 0.2 0.) > 0.9)
      then (
        let center2 = Vec3.(center +^ Vec3.make 0. (Random.float 0.5) 0.) in
        let sphere_material =
          match Random.float 1. with
          | x when Float.(x < 0.8) ->
            let albedo = Vec3.(random_color () **^ random_color ()) in
            Material.make_lambertian albedo
          | x when Float.(x < 0.95) ->
            let albedo = random_color_range 0.5 1. in
            let fuzz = Random.float 0.5 in
            Material.make_metal albedo fuzz
          | _ -> Material.make_dielectric 1.5
        in
        add sphere_material (Sphere.make_moving center center2 0.2))
    done
  done;
  (* three large spheres *)
  let material1 = Material.make_dielectric 1.5 in
  let material2 = Material.make_lambertian (Vec3.make 0.4 0.2 0.1) in
  let material3 = Material.make_metal (Vec3.make 0.7 0.6 0.5) 0.0 in
  add material1 (Sphere.make (Vec3.make 0. 1. 0.) 1.0);
  add material2 (Sphere.make (Vec3.make (-4.) 1. 0.) 1.0);
  add material3 (Sphere.make (Vec3.make 4. 1. 0.) 1.0);
  (* wrap all objects in a BVH for accelerated intersection testing *)
  let bvh_hittable = Bvh.make !spheres in
  let world = World.make [ bvh_hittable ] in
  let camera =
    Camera.make
      ~aspect_ratio:(16. /. 9.)
      ~image_width:400
      ~samples_per_pixel:5
      ~max_depth:50
      ~vfov:50.
      ~lookfrom:(Vec3.make 13. 2. 3.)
      ~lookat:(Vec3.make 0. 0. 0.)
      ~vup:(Vec3.make 0. 1. 0.)
      ~defocus_angle:0.6
      ~focus_dist:10.0
      ()
  in
  Camera.render camera world
;;

let () =
  match 0 with
  | 0 -> basic_world ()
  | 1 -> final_world ()
  | _ -> failwith "invalid world selection"
;;
