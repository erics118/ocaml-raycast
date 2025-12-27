(** interval with min and max bounds *)
type t

(** creates an interval *)
val make : float -> float -> t

(** gets the minimum value *)
val min : t -> float

(** gets the maximum value *)
val max : t -> float

(** gets the size (max - min) *)
val size : t -> float

(** checks if value is within interval *)
val surrounds : t -> float -> bool
