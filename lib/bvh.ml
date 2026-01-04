type t =
  | Leaf of Hittable.t
  | Node of
      { left : t
      ; right : t
      ; bbox : Aabb.t
      }

let box_compare axis a b =
  let a_interval = Aabb.axis_interval a.Hittable.bounding_box axis in
  let b_interval = Aabb.axis_interval b.Hittable.bounding_box axis in
  Float.compare (Interval.min a_interval) (Interval.min b_interval)
;;

(** build a BVH from a list of hittable objects *)
let rec build objects =
  let n = Array.length objects in
  if n = 0
  then failwith "cannot build bvh from empty list"
  else if n = 1
  then Leaf objects.(0)
  else (
    (* compute bounding box of all objects *)
    let bbox =
      Array.fold_left
        (fun acc obj -> Aabb.surrounding_box acc obj.Hittable.bounding_box)
        Aabb.empty
        objects
    in
    (* choose axis to split along (longest axis) *)
    let axis = Aabb.longest_axis bbox in
    (* comparator function for sorting along the chosen axis *)
    let comparator = box_compare axis in
    (* sort objects along the chosen axis *)
    Array.sort comparator objects;
    (* split in the middle *)
    let mid = n / 2 in
    let left_objs = Array.sub objects 0 mid in
    let right_objs = Array.sub objects mid (n - mid) in
    let left = build left_objs in
    let right = build right_objs in
    Node { left; right; bbox })
;;

let of_list objects = build (Array.of_list objects)

let bounding_box = function
  | Leaf h -> h.bounding_box
  | Node { bbox; _ } -> bbox
;;

let rec hit bvh ray interval =
  match bvh with
  | Leaf h -> h.hit ray interval
  | Node { left; right; bbox } ->
    if not (Aabb.hit bbox ray interval)
    then None
    else (
      let left_hit = hit left ray interval in
      let right_interval =
        match left_hit with
        | Some (hr, _) -> Interval.make (Interval.min interval) hr.Hit_record.t
        | None -> interval
      in
      let right_hit = hit right ray right_interval in
      match right_hit with
      | Some _ -> right_hit
      | None -> left_hit)
;;

let to_hittable bvh =
  { Hittable.hit = (fun ray interval -> hit bvh ray interval)
  ; bounding_box = bounding_box bvh
  }
;;

(** build a BVH from a list of hittables and return as a hittable *)
let make objects = to_hittable (of_list objects)
