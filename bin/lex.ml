let delims = Str.regexp {|\((\|)\|\{\|\}\|;\|-\|~\|!\)|}

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

let lex filename =
    let input = open_in filename in
    read_lines [] input
