let valid_source = Str.regexp {|^[^ /]+\.c$|}

(* let rec print_list arr = 
    match arr with
    | [] -> ()
    | i :: i_s -> print_endline i; print_list i_s *)

let usage = {|Usage: dune exec c-compiler file-to-read.c assembly-out.s|}


let () =
    try
        let output = Sys.argv.(2) in 
        let file = Sys.argv.(1) in
        if Str.string_match valid_source file 0
        then let tokens = (List.rev (Lex.lex file)) in
            let ast = Parse.parse tokens in
            Generate.generate ast output;
        else print_endline usage
    with Invalid_argument _ ->
        print_endline usage
