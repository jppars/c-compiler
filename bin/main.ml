let valid_source = Str.regexp {|^[^ /]+\.c$|}

let rec print_list arr = 
    match arr with
    | [] -> ()
    | i :: i_s -> print_endline i; print_list i_s

let usage = {|Usage: ./lexer file-to-lex.c|}

let () =
    try
        let file = Sys.argv.(1) in
        if Str.string_match valid_source file 0
        then print_list (List.rev (Lex.lex file))
        else print_endline usage
    with Invalid_argument _ ->
        print_endline usage
