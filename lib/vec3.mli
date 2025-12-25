type t

val make : float -> float -> float -> t
val zero : t
val x : t -> float
val y : t -> float
val z : t -> float
val neg : t -> t
val add : t -> t -> t
val sub : t -> t -> t
val scale : float -> t -> t
val div : t -> float -> t
val dot : t -> t -> float
val cross : t -> t -> t
val norm2 : t -> float
val norm : t -> float
val normalize : t -> t
val of_tuple : float * float * float -> t
val to_tuple : t -> float * float * float
val to_string : t -> string

module Infix : sig
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : float -> t -> t
end
