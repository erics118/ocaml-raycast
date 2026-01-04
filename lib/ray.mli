(** ray with origin and direction *)
type t

(** creates a ray *)
val make : ?time:float -> Vec3.t -> Vec3.t -> t

(** gets the point along ray at distance t *)
val at : t -> float -> Vec3.t

(** gets the origin *)
val origin : t -> Vec3.t

(** gets the direction *)
val direction : t -> Vec3.t

(** gets the time *)
val time : t -> float
