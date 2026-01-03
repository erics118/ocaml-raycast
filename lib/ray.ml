type t =
  { origin : Vec3.t
  ; direction : Vec3.t
  }

let make origin direction = { origin; direction }
let at r t = Vec3.(r.origin +^ (t *^ r.direction))
let origin r = r.origin
let direction r = r.direction
