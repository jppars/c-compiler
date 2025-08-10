let valid_source = Str.regexp {|^[^ /]+\.c$|}
let delims = Str.regexp {|\((\|)\|\{\|\}\|;\)|}

let rec tokenize arr input =
    match input with
    | [] -> arr
    | item :: item_ls -> tokenize (item :: arr) item_ls

let rec read_lines arr in_stream =
    match input_line in_stream with
    | exception End_of_file ->
            flush stdout;
            close_in in_stream;
            arr
    | line ->
            let spaced = Str.global_replace delims {|\1 |} line in
            let input_arr = Str.split (Str.regexp {|\([ ]+\|\b\)|}) spaced in
            let next_arr = tokenize arr input_arr in
            read_lines next_arr in_stream

let lex_file filename =
    let input = open_in filename in
    read_lines [] input

let rec print_list arr = 
    match arr with
    | [] -> ()
    | i :: i_s -> print_endline i; print_list i_s

let usage = {|Usage: ./lexer file-to-lex.c|}

let () =
    try
        let file = Sys.argv.(1) in
        if Str.string_match valid_source file 0
        then print_list (List.rev (lex_file file))
        else print_endline usage
    with Invalid_argument _ ->
        print_endline usage
