type t = Hittable.t option

let make = function
  | [] -> None
  | objects -> Some (Bvh.make objects)
;;

let bounding_box = function
  | None -> Aabb.empty
  | Some h -> h.Hittable.bounding_box
;;

let hit_world world ray interval =
  Option.bind world (fun h -> h.Hittable.hit ray interval)
;;
