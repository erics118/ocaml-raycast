(** interval with min and max bounds *)
type t

(** creates an interval *)
val make : float -> float -> t

(** empty interval (+infinity, -infinity) *)
val empty : t

(** universe interval (-infinity, +infinity) *)
val universe : t

(** gets the minimum value *)
val min : t -> float

(** gets the maximum value *)
val max : t -> float

(** gets the size (max - min) *)
val size : t -> float

(** checks if value is within interval *)
val surrounds : t -> float -> bool

(** clamps a value to be within the interval *)
val clamp : t -> float -> float

(** [expand delta] expands the interval by a given amount. ie, by [delta /. 2.]
  on the left and [delta /. 2.] on the right *)
val expand : t -> float -> t

val surrounding_interval : t -> t -> t
