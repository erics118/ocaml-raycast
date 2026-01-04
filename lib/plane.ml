type t =
  { center : Vec3.t
  ; normal : Vec3.t
  ; u : Vec3.t
  ; v : Vec3.t
  ; width : float
  ; length : float
  }

let make center normal width length =
  let n = Vec3.normalize normal in
  (* compute local axes u and v perpendicular to normal *)
  let arbitrary =
    if Float.abs (Vec3.y n) < 0.9
    then Vec3.make 0. 1. 0.
    else Vec3.make 1. 0. 0.
  in
  let u = Vec3.normalize (Vec3.cross arbitrary n) in
  let v = Vec3.cross n u in
  { center; normal = n; u; v; width; length }
;;

let hit plane r interval =
  let denom = Vec3.dot plane.normal (Ray.direction r) in
  (* if denom is ~0, ray is parallel to plane *)
  if Float.abs denom < 1e-8
  then None
  else (
    let t = Vec3.(dot (plane.center -^ Ray.origin r) plane.normal) /. denom in
    if not (Interval.surrounds interval t)
    then None
    else (
      let p = Ray.at r t in
      (* project hit point onto local plane coordinates *)
      let local = Vec3.(p -^ plane.center) in
      let u_coord = Vec3.dot local plane.u in
      let v_coord = Vec3.dot local plane.v in
      (* check if within bounds *)
      let half_w = plane.width /. 2. in
      let half_l = plane.length /. 2. in
      if Float.abs u_coord > half_w || Float.abs v_coord > half_l
      then None
      else (
        let is_front_face = denom < 0. in
        Some
          { Hit_record.p
          ; normal =
              (if is_front_face then plane.normal else Vec3.neg plane.normal)
          ; t
          ; front_face = is_front_face
          })))
;;

let to_hittable plane mat =
  { Hittable.hit =
      (fun ray interval ->
        match hit plane ray interval with
        | Some hr -> Some (hr, mat)
        | None -> None)
      (* TODO *)
  ; bounding_box = Aabb.empty
  }
;;

let make_hittable center normal width length mat =
  to_hittable (make center normal width length) mat
;;
