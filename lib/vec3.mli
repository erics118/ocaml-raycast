(** 3d vector *)
type t

(** [make x y z] creates a vector *)
val make : float -> float -> float -> t

(** the zero vector *)
val zero : t

(** gets the x component *)
val x : t -> float

(** gets the y component *)
val y : t -> float

(** gets the z component *)
val z : t -> float

(** negates the vector *)
val neg : t -> t

(** adds two vectors *)
val add : t -> t -> t

(** subtracts two vectors *)
val sub : t -> t -> t

(** scales the vector by a float *)
val scale : float -> t -> t

(** divides the vector by a float *)
val div : t -> float -> t

(** gets the dot product of two vectors *)
val dot : t -> t -> float

(** gets the cross product of two vectors *)
val cross : t -> t -> t

(** gets the squared length *)
val norm2 : t -> float

(** gets the length of the vector *)
val norm : t -> float

(** normalizes the vector to unit length *)
val normalize : t -> t

(** creates a vector from tuple *)
val of_tuple : float * float * float -> t

(** converts the vector to tuple *)
val to_tuple : t -> float * float * float

(** converts the vector to string *)
val to_string : t -> string

module Infix : sig
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : float -> t -> t
  val ( / ) : t -> float -> t
end
