(lang dune 3.20)

(name raytracer)

(generate_opam_files true)

(source
 (github erics118/ocaml-raytracer))

(authors "erics118")

(maintainers "erics118")

(license LICENSE)

(documentation https://github.com/erics118/ocaml-raytracer)

(package
 (name raytracer)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml core ppx_deriving ppx_inline_test)
 (tags
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
