#!/usr/bin/env ocaml
#use "topfind"
#require "topkg"
open Topkg

let metas = [
  Pkg.meta_file ~install:false "pkg/META";
  Pkg.meta_file ~install:false "pkg/META.lwt";
]

let opams =
  let opam no_lint name =
    Pkg.opam_file ~lint_deps_excluding:(Some no_lint) ~install:false name
  in
  [
  opam ["lwt"; "mirage-time"] "opam";
  opam ["mirage-device"] "mirage-time-lwt.opam";
  ]

let () =
  Pkg.describe ~metas ~opams "mirage-time" @@ fun c ->
  match Conf.pkg_name c with
  | "mirage-time" ->
    Ok [ Pkg.lib "pkg/META";
         Pkg.lib ~exts:Exts.interface "src/mirage_time" ]
  | "mirage-time-lwt" ->
    Ok [ Pkg.lib "pkg/META.lwt" ~dst:"META";
         Pkg.lib ~exts:Exts.interface "src/mirage_time_lwt" ]
  | other ->
    R.error_msgf "unknown package name: %s" other
