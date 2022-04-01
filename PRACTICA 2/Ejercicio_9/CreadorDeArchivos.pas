program crear;

type

cMaestro = record
	codP:integer;
	codL:integer;
	nro:integer;
	cantV:integer;
end;


maestro = file of cMaestro;

procedure imprimirCl(c:cMaestro);
begin
	with c do begin
		writeln ('CODIGO PROVINCIA: ',codP);
		writeln ('CODIGO LOCALIDAD: ',codL);
		writeln ('NUMERO MESA: ',nro);
		writeln ('CANTIDAD VOTOS: ',cantV);
		writeln ('');
	end;
end;

procedure leerCl (var c:cMaestro);
begin
	with C do begin
		write ('INGRESE CODIGO PROVINCIA: '); readln (codP);
		if (codP <> -1) then begin
			write ('INGRESE CODIGO LOCALIDAD: '); readln (codL);
			write ('NUMERO DE MESA: '); readln (nro);
			write ('INGRESE CANTIDAD VOTOS: '); readln (cantV);
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
	while (c.codP <> -1) do begin
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
