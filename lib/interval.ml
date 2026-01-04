type t =
  { min : float
  ; max : float
  }

let make min max = { min; max }
let min i = i.min
let max i = i.max
let size i = i.max -. i.min
let surrounds i x = x >= i.min && x <= i.max
let clamp i x = Float.max i.min (Float.min i.max x)

let expand i delta =
  let half = delta /. 2. in
  { min = i.min -. half; max = i.max +. half }
;;
