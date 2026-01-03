open Core
module Vec3 = Raytracer.Vec3
module Ray = Raytracer.Ray

(* basic tests *)

let eps = 1e-9
let float_eq a b = Float.(abs (a -. b) < eps)

let%test "vec3_zero" =
  let v = Vec3.zero in
  Float.(Vec3.x v = 0. && Vec3.y v = 0. && Vec3.z v = 0.)
;;

let%test "vec3_make" =
  let v = Vec3.make 1. 2. 3. in
  Float.(Vec3.x v = 1. && Vec3.y v = 2. && Vec3.z v = 3.)
;;

let%test "vec3_add" =
  let v1 = Vec3.make 1. 2. 3. in
  let v2 = Vec3.make 4. 5. 6. in
  let sum = Vec3.add v1 v2 in
  float_eq (Vec3.x sum) 5.
  && float_eq (Vec3.y sum) 7.
  && float_eq (Vec3.z sum) 9.
;;

let%test "vec3_norm" =
  let v = Vec3.make 3. 4. 0. in
  float_eq (Vec3.norm v) 5.
;;

let%test "ray_make" =
  let origin = Vec3.zero in
  let direction = Vec3.make 1. 0. 0. in
  let r = Ray.make origin direction in
  Float.(Vec3.x (Ray.origin r) = 0. && Vec3.x (Ray.direction r) = 1.)
;;

let%test "ray_at" =
  let origin = Vec3.zero in
  let direction = Vec3.make 1. 0. 0. in
  let r = Ray.make origin direction in
  let point = Ray.at r 2. in
  float_eq (Vec3.x point) 2.
  && float_eq (Vec3.y point) 0.
  && float_eq (Vec3.z point) 0.
;;
