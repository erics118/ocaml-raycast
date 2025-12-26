module V = Vec3

val write_color : out_channel -> V.t -> unit
(** [write_color oc color] writes color as rgb values to output stream, scaled
    to [0,255] *)
