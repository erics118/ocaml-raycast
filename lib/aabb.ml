(** axis-aligned bounding box *)

type t =
  { x : Interval.t
  ; y : Interval.t
  ; z : Interval.t
  }

let x aabb = aabb.x
let y aabb = aabb.y
let z aabb = aabb.z
let make x y z = { x; y; z }
let empty = make Interval.empty Interval.empty Interval.empty
let universe = make Interval.universe Interval.universe Interval.universe

let of_points a b =
  let min_x = Float.min (Vec3.x a) (Vec3.x b) in
  let max_x = Float.max (Vec3.x a) (Vec3.x b) in
  let min_y = Float.min (Vec3.y a) (Vec3.y b) in
  let max_y = Float.max (Vec3.y a) (Vec3.y b) in
  let min_z = Float.min (Vec3.z a) (Vec3.z b) in
  let max_z = Float.max (Vec3.z a) (Vec3.z b) in
  make
    (Interval.make min_x max_x)
    (Interval.make min_y max_y)
    (Interval.make min_z max_z)
;;

let to_list aabb = [ aabb.x; aabb.y; aabb.z ]

let surrounding_box box0 box1 =
  make
    (Interval.surrounding_interval box0.x box1.x)
    (Interval.surrounding_interval box0.y box1.y)
    (Interval.surrounding_interval box0.z box1.z)
;;

let hit aabb r ray_t =
  let origins = Vec3.to_list (Ray.origin r) in
  let directions = Vec3.to_list (Ray.direction r) in
  (* zip together: [(x_interval, x_origin, x_direction); (y_...); (z_...)] *)
  let axes = List.combine (List.combine (to_list aabb) origins) directions in
  let result =
    List.fold_left
      (fun acc ((ax, orig), dir) ->
         match acc with
         | None -> None (* Already failed on a previous axis *)
         | Some (tmin, tmax) ->
           let eps = 1e-12 in
           if Float.abs dir < eps
           then (
             (* Ray parallel to slab: miss if origin outside interval *)
             if orig < Interval.min ax || orig > Interval.max ax
             then None
             else Some (tmin, tmax))
           else (
             let adinv = 1.0 /. dir in
             (* time when the ray enters the slab *)
             let t0 = (Interval.min ax -. orig) *. adinv in
             (* time when the ray exits the slab *)
             let t1 = (Interval.max ax -. orig) *. adinv in
             (* if direction is negative, adinv is negative, so t0 > t1. we need
                t0 to be entry time (smaller) and t1 to be exit time (larger) *)
             let tmin, tmax =
               if t0 < t1
               then Float.max tmin t0, Float.min tmax t1
               else Float.max tmin t1, Float.min tmax t0
             in
             (* if range is now empty or inverted, ray misses the box *)
             if tmax <= tmin then None else Some (tmin, tmax)))
      (Some (Interval.min ray_t, Interval.max ray_t))
      axes
  in
  Option.is_some result
;;

let longest_axis aabb =
  let sx = Interval.size aabb.x in
  let sy = Interval.size aabb.y in
  let sz = Interval.size aabb.z in
  if sx > sy then if sx > sz then 0 else 2 else if sy > sz then 1 else 2
;;

let axis_interval aabb i =
  match i with
  | 0 -> aabb.x
  | 1 -> aabb.y
  | _ -> aabb.z
;;
