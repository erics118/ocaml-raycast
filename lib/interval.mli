type t
(** interval with min and max bounds *)

val make : float -> float -> t
(** creates an interval *)

val min : t -> float
(** gets the minimum value *)

val max : t -> float
(** gets the maximum value *)

val size : t -> float
(** gets the size (max - min) *)

val surrounds : t -> float -> bool
(** checks if value is within interval *)
