type t = { objects : Hittable.hittable list }

let make spheres = { objects = List.map Hittable.make_sphere spheres }

(* determine if the ray hits anything in the world *)
let hit_world (world : t) ray interval : Hit_record.t option =
  let rec aux objs closest_so_far acc =
    match objs with
    | [] -> acc
    | obj :: rest ->
        let test_interval = Interval.make (Interval.min interval) closest_so_far in
        (match Hittable.hit obj ray test_interval with
        | Some hr -> aux rest hr.t (Some hr)
        | None -> aux rest closest_so_far acc)
  in
  aux world.objects (Interval.max interval) None
