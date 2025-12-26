type t = { min : float; max : float }

let make min max = { min; max }
let min i = i.min
let max i = i.max
let size i = i.max -. i.min
let surrounds i x = x >= i.min && x <= i.max
