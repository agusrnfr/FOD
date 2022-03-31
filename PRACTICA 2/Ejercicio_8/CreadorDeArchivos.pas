program crear;

type

cliente = record
	cod:integer;
	NyA: string;
	anio: integer;
	mes: 1..12;
	dia: 1..31;
	montoV:real;
end;

maestro = file of cliente;

procedure imprimirCl(c:cliente);
begin
	with c do begin
		writeln ('CODIGO: ',cod);
		writeln ('NOMBRE: ',NyA);
		writeln ('ANIO ',anio);
		writeln ('MES: ',mes);
		writeln ('DIA: ',dia);
		writeln ('MONTO: ',montoV:1:1);
		writeln ('');
	end;
end;

procedure leerCl (var c:cliente);
begin
	with C do begin
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE NOMBRE Y APELLIDO: '); readln (NyA);
			write ('INGRESE ANIO: '); readln (anio);
			write ('INGRESE MES: '); readln (mes);
			write ('INGRESE DIA: '); readln (dia);
			write ('INGRESE MONTO: '); readln (montoV);
		end;
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
c:cliente;
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
c:cliente;
begin
	rewrite (arc_maestro);
	leerCl (c);
	while (c.cod <> -1) do begin
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
