exception ParseError of string
(* type 'a tree =
    | Leaf
    | Node of 'a * 'a tree list *)

type expr =
    | Const of int
type statement =
    | Return of expr
type func =
    | Func of string * statement
type prog =
    | Prog of func

(* type 'a ast_node =
    | AST_node of 'a *)

let valid_keywords = Str.regexp {|\(^return$\|^int$\)|}
let is_int = Str.regexp {|[0-9]+|}

let parse_exp token =
    match (Str.string_match is_int token 0) with
    | true -> Const(int_of_string token)
    | _ -> raise (ParseError "Provided token is not a valid expression")

let parse_statement tokens =
    match tokens with
    | [] -> raise (ParseError "No valid tokens to parse for statement")
    | keyword :: value :: semicolon :: tok_s ->
        let word_check = (Str.string_match valid_keywords keyword 0) in
        let exp_node = (parse_exp value) in
        let Const(exp_val) = exp_node in
        let semi_val = (semicolon = ";") in
        (match word_check && (exp_val >= 0) && semi_val with
        | true -> (Return(exp_node), tok_s)
        | _ -> raise (ParseError "No valid statement patterns in token list"))
    | _ :: [] -> raise (ParseError "No matching statement patterns in token list")
    | _ :: _ :: [] -> raise (ParseError "No matching statement patterns in token list")

let parse_func tokens =
    match tokens with
    | [] -> raise (ParseError "No valid tokens to parse for function")
    | arg1 :: arg2 :: arg3 :: arg4 :: arg5 :: tok_s ->
        (match arg1 = "int", arg3 = "(", arg4 = ")", arg5 = "{" with
        | (true, true, true, true) -> 
            let statement, tok_states = parse_statement tok_s in
            (match tok_states with
            | [] -> raise (ParseError "Missing \"}\" expected")
            | arg :: tokens_left ->
                (match arg = "}" with
                | true -> (Func(arg2, statement), tokens_left)
                | _ -> raise (ParseError "Missing \"}\" expected")))
        | _ -> raise (ParseError "No matching function patterns in token list"))
    | _ :: [] -> raise (ParseError "No matching function patterns in token list")
    | _ :: _ :: [] -> raise (ParseError "No matching function patterns in token list")
    | _ :: _ :: _ :: [] -> raise (ParseError "No matching function patterns in token list")
    | _ :: _ :: _ :: _ :: [] -> raise (ParseError "No matching function patterns in token list")

let parse tokens =
    let func, tokens_left = parse_func tokens in
    let program = Prog(func) in
    (program, tokens_left)

