type t
(** ray with origin and direction *)

val make : Vec3.t -> Vec3.t -> t
(** creates a ray *)

val at : t -> float -> Vec3.t
(** gets the point along ray at distance t *)

val origin : t -> Vec3.t
(** gets the origin *)

val direction : t -> Vec3.t
(** gets the direction *)
