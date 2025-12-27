(** contains the intersection point, normal vector, distance, and face
    orientation *)
type t =
  { p : Vec3.t
  ; normal : Vec3.t
  ; t : float
  ; front_face : bool
  }
