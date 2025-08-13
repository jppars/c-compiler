exception ParseError of string
(* type 'a tree =
    | Leaf
    | Node of 'a * 'a tree list *)

type unop =
    | SignNeg
    | BitInv
    | LogNeg
type expr =
    | Const of int
    | UnOp of unop * expr
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

let rec parse_exp tokens =
    match tokens with
    | [] -> raise (ParseError "No provided tokens to parse expression")
    | token :: tokens_left ->
        (match Str.string_match is_int token 0 with
        | true -> (Const(int_of_string token), tokens_left)
        | _ ->
            (match token with
            | "~" -> let expression, popped_tokens = parse_exp tokens_left in
                    (UnOp(BitInv, expression), popped_tokens)
            | "!" -> let expression, popped_tokens = parse_exp tokens_left in
                    (UnOp(LogNeg, expression), popped_tokens)
            | "-" -> let expression, popped_tokens = parse_exp tokens_left in
                    (UnOp(SignNeg, expression), popped_tokens)
            | _ -> raise (ParseError "Provided token sequence is not a valid expression")))

let parse_statement tokens =
    match tokens with
    | [] -> raise (ParseError "No valid tokens to parse for statement")
    | keyword :: tok_s ->
        (match (Str.string_match valid_keywords keyword 0) with
        | false -> raise (ParseError "Statement does not start with keyword. Sorry :P")
        | true -> let expression, popped_tokens = parse_exp tok_s in
            (match popped_tokens with
            | [] -> raise (ParseError "Invalid statement. Semicolon Expected")
            | semicolon :: popped_statement -> 
                (match semicolon = ";" with
                | true -> (Return(expression), popped_statement)
                | _ -> raise (ParseError "Invalid statement. Semicolon Expected"))
            )
        )

let parse_func tokens =
    match tokens with
    | [] -> raise (ParseError "No valid tokens to parse for function")
    | arg1 :: arg2 :: arg3 :: arg4 :: arg5 :: tok_s ->
        (match arg1 = "int", arg2 = "main", arg3 = "(", arg4 = ")", arg5 = "{" with
        | (true, true, true, true, true) -> 
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
    match tokens_left with
    | [] -> program
    | _ -> raise (ParseError "Too many tokens provided to parser. Syntax invalid")

