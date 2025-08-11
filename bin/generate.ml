exception GenerationError of string

let generate ast output =
    let Parse.Prog(Parse.Func(func_name, statement)) = ast in
    match statement with
    | Parse.Return(Parse.Const(value)) ->
            let oc = open_out output in
            Printf.fprintf oc "  .globl %s\n" func_name;
            Printf.fprintf oc "%s:\n" func_name;
            Printf.fprintf oc "    movl   $%d, %%eax\n" value;
            Printf.fprintf oc "    ret\n";
            close_out oc
    (* | _ -> raise (GenerationError "Passed AST is not yet implemented in Generate") *)
