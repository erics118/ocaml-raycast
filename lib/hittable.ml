type hittable = Sphere of Sphere.t

let make_sphere s = Sphere s

let hit (obj : hittable) ray interval : Hit_record.t option =
  match obj with Sphere s -> Sphere.hit s ray interval
