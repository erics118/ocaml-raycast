type t
(** 3d vector *)

val make : float -> float -> float -> t
(** [make x y z] creates a vector *)

val zero : t
(** the zero vector *)

val x : t -> float
(** gets the x component *)

val y : t -> float
(** gets the y component *)

val z : t -> float
(** gets the z component *)

val neg : t -> t
(** negates the vector *)

val add : t -> t -> t
(** adds two vectors *)

val sub : t -> t -> t
(** subtracts two vectors *)

val scale : float -> t -> t
(** scales the vector by a float *)

val div : t -> float -> t
(** divides the vector by a float *)

val dot : t -> t -> float
(** gets the dot product of two vectors *)

val cross : t -> t -> t
(** gets the cross product of two vectors *)

val norm2 : t -> float
(** gets the squared length *)

val norm : t -> float
(** gets the length of the vector *)

val normalize : t -> t
(** normalizes the vector to unit length *)

val of_tuple : float * float * float -> t
(** creates a vector from tuple *)

val to_tuple : t -> float * float * float
(** converts the vector to tuple *)

val to_string : t -> string
(** converts the vector to string *)

module Infix : sig
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : float -> t -> t
  val ( / ) : t -> float -> t
end
