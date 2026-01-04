type t =
  { origin : Vec3.t
  ; direction : Vec3.t
  ; time : float
  }

let make ?(time = 0.0) origin direction = { time; origin; direction }
let at r t = Vec3.(r.origin +^ (t *^ r.direction))
let origin r = r.origin
let direction r = r.direction
let time r = r.time
