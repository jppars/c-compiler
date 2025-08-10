lexer: lexer/bin/main.ml
	dune build --root=./lexer

return2: return_2.c
	cc -o return_2 return_2.c

clean:
	rm return_2.o return_2
