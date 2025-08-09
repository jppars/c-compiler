let file = Sys.argv.(1)
(* let to_lex = open_in file *)
let rec print_lines in_stream = 
    match input_line in_stream with
    | exception End_of_file -> 
            flush stdout;
            close_in in_stream
    | line -> 
            print_endline line;
            print_lines in_stream 

let read_file filename = 
    let input = open_in file in
    print_lines input

let () =
    read_file file
