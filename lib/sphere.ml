type t =
  { center : Ray.t
  ; radius : float
  }

let make center radius = { center = Ray.make center Vec3.zero; radius }

let make_moving center center2 radius =
  { center = Ray.make center Vec3.(center2 -^ center); radius }
;;

let hit s r interval =
  let current_center = Ray.at s.center (Ray.time r) in
  let oc = Vec3.(Ray.origin r -^ current_center) in
  let a = Vec3.norm2 (Ray.direction r) in
  let half_b = Vec3.dot oc (Ray.direction r) in
  let c = Vec3.norm2 oc -. (s.radius *. s.radius) in
  let discriminant = (half_b *. half_b) -. (a *. c) in
  if discriminant < 0.0
  then None
  else (
    let sqrtd = sqrt discriminant in
    (* find nearest root that is in the valid range *)
    let r1 = (-.half_b -. sqrtd) /. a in
    let r2 = (-.half_b +. sqrtd) /. a in
    let root =
      if Interval.surrounds interval r1
      then Some r1
      else if Interval.surrounds interval r2
      then Some r2
      else None
    in
    (* make the hit record *)
    match root with
    | None -> None
    | Some root ->
      let p = Ray.at r root in
      let outward_normal = Vec3.((p -^ current_center) /^ s.radius) in
      let is_front_face = Vec3.dot (Ray.direction r) outward_normal < 0. in
      Some
        { Hit_record.p
        ; normal =
            (if is_front_face then outward_normal else Vec3.neg outward_normal)
        ; t = root
        ; front_face = is_front_face
        })
;;

(** compute the bounding box for a sphere.
    For moving spheres, returns a box that contains the sphere at all times 0-1. *)
let bounding_box s =
  let r_vec = Vec3.make s.radius s.radius s.radius in
  (* box at time 0 *)
  let center0 = Ray.origin s.center in
  let box0 = Aabb.of_points Vec3.(center0 -^ r_vec) Vec3.(center0 +^ r_vec) in
  (* box at time 1 *)
  let center1 = Ray.at s.center 1.0 in
  let box1 = Aabb.of_points Vec3.(center1 -^ r_vec) Vec3.(center1 +^ r_vec) in
  (* union of both boxes *)
  Aabb.surrounding_box box0 box1
;;

let to_hittable s mat =
  { Hittable.hit =
      (fun ray interval ->
        match hit s ray interval with
        | Some hr -> Some (hr, mat)
        | None -> None)
  ; bounding_box = bounding_box s
  }
;;
