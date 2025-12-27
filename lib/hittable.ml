type hittable = Sphere of Sphere.t

let hit (obj : hittable) ray interval : Hit_record.t option =
  match obj with
  | Sphere s -> Sphere.hit s ray interval
;;
