(** [write_color oc color] writes color as rgb values to output stream, scaled
    to [0,255] *)
val write_color : out_channel -> Vec3.t -> unit
