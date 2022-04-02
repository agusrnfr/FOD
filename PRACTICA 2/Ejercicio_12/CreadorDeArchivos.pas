program crear;

type
a = -1..2023;
me = 1..12;
d = 1..31;

cMaestro = record
	anio:a;
	mes:me;
	dia:d;
	idUs:integer;
	tiempoAc: real;
end;

maestro = file of cMaestro;

procedure imprimirCl(c:cMaestro);
begin
	with c do begin
		writeln ('ANIO: ',anio,' MES: ',mes,' DIA: ',dia,' ID USUARIO: ',idUs,' TIEMPO DE ACCESO: ',tiempoAc:2:2);
		writeln ('');
	end;
end;

procedure leerCl (var c:cMaestro);
begin
	with C do begin
		write ('ANIO: '); readln (anio);
		if (anio <> -1) then begin
			write ('INGRESE MES: '); readln (mes);
			write ('INGRESE DIA: '); readln (dia);
			write ('INGRESE ID USUARIO: '); readln (idUs);
			write ('INGRESE TIEMPO ACCESO: '); readln (tiempoAc);
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
	while (c.anio <> -1) do begin
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


