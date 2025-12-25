type t

val make : Vec3.t -> Vec3.t -> t
val at : t -> float -> Vec3.t
val origin : t -> Vec3.t
val direction : t -> Vec3.t
