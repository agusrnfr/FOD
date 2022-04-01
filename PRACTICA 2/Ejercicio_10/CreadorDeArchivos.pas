program crear;

CONST
n = 15;

type
categ = 1..n;
cMaestro = record
	departamento:integer;
	division:integer;
	nro:integer;
	categoria:categ;
	cantHoras:integer;
end;


maestro = file of cMaestro;

procedure imprimirCl(c:cMaestro);
begin
	with c do begin
		writeln ('DEPARTAMENTO: ',departamento);
		writeln ('DIVISION: ',division);
		writeln ('NRO: ',nro);
		writeln ('CATEGORIA: ',categoria);
		writeln ('CANTIDAD HORAS: ',cantHoras);
		writeln ('');
	end;
end;

procedure leerCl (var c:cMaestro);
begin
	with C do begin
		write ('INGRESE DEPARTAMENTO: '); readln (departamento);
		if (departamento <> -1) then begin
			write ('INGRESE DIVISION: '); readln (division);
			write ('INGRESE NRO: '); readln (nro);
			write ('INGRESE CATEGORIA: '); readln (categoria);
			write ('INGRESE CANTIDAD HORAS: '); readln (cantHoras)
		end;
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
c:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,c);
		imprimirCl(c);
	end;
	close (arc_maestro);
end;

procedure crear (var arc_maestro:maestro);
var
c:cMaestro;
begin
	rewrite (arc_maestro);
	leerCl (c);
	while (c.departamento <> -1) do begin
		write (arc_maestro,c);
		leerCl(c);
	end;
	close (arc_maestro);
end;

var
arc_maestro:maestro;
begin
	Assign (arc_maestro,'maestro');
	{crear (arc_maestro);}
	mostrarMaestro (arc_maestro);
end.

