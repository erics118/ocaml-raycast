type t =
  { x : float
  ; y : float
  ; z : float
  }

(* constructors *)
let[@inline] make x y z = { x; y; z }
let zero = make 0. 0. 0.

(* accessors *)
let[@inline] x v = v.x
let[@inline] y v = v.y
let[@inline] z v = v.z

(* basic operations *)
let[@inline] neg v = make (-.v.x) (-.v.y) (-.v.z)
let[@inline] add a b = make (a.x +. b.x) (a.y +. b.y) (a.z +. b.z)
let[@inline] sub a b = make (a.x -. b.x) (a.y -. b.y) (a.z -. b.z)
let[@inline] mul a b = make (a.x *. b.x) (a.y *. b.y) (a.z *. b.z)
let[@inline] scale k v = make (k *. v.x) (k *. v.y) (k *. v.z)
let[@inline] div v k = make (v.x /. k) (v.y /. k) (v.z /. k)

(* infix operators *)
let[@inline] ( +^ ) a b = add a b
let[@inline] ( -^ ) a b = sub a b
let[@inline] ( *^ ) k v = scale k v
let[@inline] ( **^ ) a b = mul a b
let[@inline] ( /^ ) v k = div v k

(* dot, cross *)
let[@inline] dot a b = (a.x *. b.x) +. (a.y *. b.y) +. (a.z *. b.z)

let[@inline] cross a b =
  make
    ((a.y *. b.z) -. (a.z *. b.y))
    ((a.z *. b.x) -. (a.x *. b.z))
    ((a.x *. b.y) -. (a.y *. b.x))
;;

(* norms *)
let[@inline] norm2 v = dot v v
let[@inline] norm v = sqrt (norm2 v)

let[@inline] normalize v =
  let n = norm v in
  if n = 0. then zero else 1. /. n *^ v
;;

(* conversions *)
let of_tuple (x, y, z) = make x y z
let to_tuple v = v.x, v.y, v.z
let to_string v = Printf.sprintf "(%g, %g, %g)" v.x v.y v.z
let to_list v = [ v.x; v.y; v.z ]

(* random vectors *)
let random_unit_vector () =
  let theta = Random.float (2. *. Float.pi) in
  (* random float between -1 and 1 *)
  let z = Random.float 2. -. 1. in
  let r = sqrt (1. -. (z *. z)) in
  let x = r *. cos theta in
  let y = r *. sin theta in
  make x y z
;;

let[@inline] near_zero v =
  let s = 1e-8 in
  Float.abs v.x < s && Float.abs v.y < s && Float.abs v.z < s
;;

let[@inline] reflect v n = sub v (2. *. dot v n *^ n)

let[@inline] refract uv n etai_over_etat =
  let cos_theta = Float.min (dot (neg uv) n) 1. in
  let r_out_perp = etai_over_etat *^ (uv +^ (cos_theta *^ n)) in
  let r_out_parallel = -.Float.sqrt (Float.abs (1. -. norm2 r_out_perp)) *^ n in
  add r_out_perp r_out_parallel
;;
