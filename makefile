lexer: lexer.ml
	ocamlopt -o lexer lexer.ml

return2: return_2.c
	cc -o return_2 return_2.c

clean:
	rm lexer.cmi lexer.cmx lexer.o lexer return_2.o return_2
