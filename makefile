_:
	dune build

exec:
	dune exec c-compiler return_2.c

return2: return_2.c
	cc -o return_2 return_2.c

clean:
	rm return_2.o return_2
