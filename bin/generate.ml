exception GenerationError of string

let rec eval_expr expr oc =
    match expr with
    | Parse.Const(value) ->
        Printf.fprintf oc "    movl   $%d, %%eax\n" value;
    | Parse.UnOp(op, nested_expr) ->
        eval_expr nested_expr oc;
        (match op with
        | Parse.LogNeg ->
            Printf.fprintf oc "    cmpl  $0,  %%eax\n";
            Printf.fprintf oc "    movl  $0,  %%eax\n";
            Printf.fprintf oc "    sete  %%al\n"
        | Parse.SignNeg ->
            Printf.fprintf oc "    neg   %%eax\n"
        | Parse.BitInv ->
            Printf.fprintf oc "    not   %%eax\n"
        (* | _ -> raise (GenerationError "Unexpected operator in expression evaluation") *)
        )
    (* | _ -> raise (GenerationError "Unexpected expression type in generation") *)


let eval_statement state oc =
    match state with
    | Parse.Return(expr) ->
        eval_expr expr oc;
        Printf.fprintf oc "    ret\n"
    (* | _ -> raise (GenerationError "Unexpected statement type in generation") *)

let generate ast output =
    let Parse.Prog(Parse.Func(func_name, statement)) = ast in
    let oc = open_out output in
    Printf.fprintf oc "  .globl %s\n" func_name;
    Printf.fprintf oc "%s:\n" func_name;
    eval_statement statement oc;
    close_out oc
    (* | _ -> raise (GenerationError "Passed AST is not yet implemented in Generate") *)
