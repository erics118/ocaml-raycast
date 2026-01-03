open Core
module V = Raytracer.Vec3
module R = Raytracer.Ray
module C = Raytracer.Color

(* basic tests *)

let eps = 1e-9
let float_eq a b = Float.(abs (a -. b) < eps)

let%test "vec3_zero" =
  let v = V.zero in
  Float.(V.x v = 0. && V.y v = 0. && V.z v = 0.)
;;

let%test "vec3_make" =
  let v = V.make 1. 2. 3. in
  Float.(V.x v = 1. && V.y v = 2. && V.z v = 3.)
;;

let%test "vec3_add" =
  let v1 = V.make 1. 2. 3. in
  let v2 = V.make 4. 5. 6. in
  let sum = V.add v1 v2 in
  float_eq (V.x sum) 5. && float_eq (V.y sum) 7. && float_eq (V.z sum) 9.
;;

let%test "vec3_norm" =
  let v = V.make 3. 4. 0. in
  float_eq (V.norm v) 5.
;;

let%test "ray_make" =
  let origin = V.zero in
  let direction = V.make 1. 0. 0. in
  let r = R.make origin direction in
  Float.(V.x (R.origin r) = 0. && V.x (R.direction r) = 1.)
;;

let%test "ray_at" =
  let origin = V.zero in
  let direction = V.make 1. 0. 0. in
  let r = R.make origin direction in
  let point = R.at r 2. in
  float_eq (V.x point) 2. && float_eq (V.y point) 0. && float_eq (V.z point) 0.
;;
