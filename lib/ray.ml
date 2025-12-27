module V = Vec3
open V.Infix

type t =
  { origin : V.t
  ; direction : V.t
  }

let make origin direction = { origin; direction }
let at r t = r.origin + (t * r.direction)
let origin r = r.origin
let direction r = r.direction
