module V = Vec3
module R = Ray

type t =
  { center : Vec3.t
  ; radius : float
  }

let make center radius = { center; radius }

let hit s r interval =
  let oc = V.(R.origin r -^ s.center) in
  let a = V.norm2 (R.direction r) in
  let half_b = V.dot oc (R.direction r) in
  let c = V.norm2 oc -. (s.radius *. s.radius) in
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
      let p = R.at r root in
      let outward_normal = V.((p -^ s.center) /^ s.radius) in
      let is_front_face = V.dot (R.direction r) outward_normal < 0. in
      Some
        { Hit_record.p
        ; normal = (if is_front_face then outward_normal else V.neg outward_normal)
        ; t = root
        ; front_face = is_front_face
        })
;;

let to_hittable s mat =
  { Hittable.hit =
      (fun ray interval ->
        match hit s ray interval with
        | Some hr -> Some (hr, mat)
        | None -> None)
  }
;;
