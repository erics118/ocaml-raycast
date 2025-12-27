type t =
  { x : float
  ; y : float
  ; z : float
  }

(* constructors *)
let make x y z = { x; y; z }
let zero = make 0. 0. 0.

(* accessors *)
let x v = v.x
let y v = v.y
let z v = v.z

(* basic operations *)
let neg v = make (-.v.x) (-.v.y) (-.v.z)
let add a b = make (a.x +. b.x) (a.y +. b.y) (a.z +. b.z)
let sub a b = make (a.x -. b.x) (a.y -. b.y) (a.z -. b.z)
let scale k v = make (k *. v.x) (k *. v.y) (k *. v.z)
let div v k = make (v.x /. k) (v.y /. k) (v.z /. k)

(* dot, cross *)
let dot a b = (a.x *. b.x) +. (a.y *. b.y) +. (a.z *. b.z)

let cross a b =
  make
    ((a.y *. b.z) -. (a.z *. b.y))
    ((a.z *. b.x) -. (a.x *. b.z))
    ((a.x *. b.y) -. (a.y *. b.x))
;;

(* norms *)
let norm2 v = dot v v
let norm v = sqrt (norm2 v)

let normalize v =
  let n = norm v in
  if n = 0. then zero else scale (1. /. n) v
;;

(* conversions *)
let of_tuple (x, y, z) = make x y z
let to_tuple v = v.x, v.y, v.z
let to_string v = Printf.sprintf "(%g, %g, %g)" v.x v.y v.z

let random_unit_vector () =
  let theta = Random.float (2. *. Float.pi) in
  (* random float between -1 and 1 *)
  let z = Random.float 2. -. 1. in
  let r = sqrt (1. -. (z *. z)) in
  let x = r *. cos theta in
  let y = r *. sin theta in
  make x y z
;;

let random_unit_vector_on_hemisphere normal =
  let unit_vector = random_unit_vector () in
  if dot unit_vector normal > 0.0 then unit_vector else neg unit_vector
;;

(* infix operators *)
let ( +^ ) = add
let ( -^ ) = sub
let ( *^ ) k v = scale k v
let ( /^ ) v k = div v k
