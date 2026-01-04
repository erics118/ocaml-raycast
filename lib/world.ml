type t =
  { objects : Hittable.t list
  ; bbox : Aabb.t
  }

let make = function
  | [] -> { objects = []; bbox = Aabb.empty }
  | _ as objects ->
    let bvh = Bvh.make objects in
    { objects = [ bvh ]; bbox = bvh.bounding_box }
;;

let bounding_box world = world.bbox

let hit_world world ray interval =
  let rec aux objs closest_so_far acc =
    match objs with
    | [] -> acc
    | obj :: rest ->
      let test_i = Interval.make (Interval.min interval) closest_so_far in
      (match obj.Hittable.hit ray test_i with
       | Some (hr, mat) -> aux rest hr.t (Some (hr, mat))
       | None -> aux rest closest_so_far acc)
  in
  aux world.objects (Interval.max interval) None
;;
