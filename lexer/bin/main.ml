let rec print_lines in_stream =
    match input_line in_stream with
    | exception End_of_file ->
            flush stdout;
            close_in in_stream
    | line -> 
            print_endline line;
            print_lines in_stream 

let read_file filename =
    let input = open_in filename in
    print_lines input

let valid_source = Str.regexp {|[^ /]+\.c|}

let usage = print_endline {|Usage: ./lexer file-to-lex.c|}

let () =
    try
        let file = Sys.argv.(1) in
        if Str.string_match valid_source file 0
        then read_file file
        else print_endline file
    with Invalid_argument _ ->
        usage
