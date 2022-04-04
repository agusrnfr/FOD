program creadorArchivos;
uses crt;

CONST
n = 3;

type

cMaestro = record
	fecha:string;
	cod:integer;
	nombre:string;
	des:string;
	precio:real;
	totalE:integer;
	totalEVendidos:integer;
end;

cDetalle = record
	fecha:string;
	cod:integer;
	cantV:integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;

procedure leerMaestro (var c: cMaestro);
begin
	with c do begin 
		write ('INGRESE FECHA: '); readln (fecha);
		if (fecha <> ' ') then begin
			write ('INGRESE CODIGO SUCURSAL: '); readln (cod);
			write ('INGRESE NOMBRE SUCURSAL: '); readln (nombre);
			write ('INGRESE PRECIO: '); readln (precio);
			write ('INGRESE TOTAL EJEMPLARES: '); readln (totalE);
			write ('INGRESE TOTAL DE EJEMPLARES VENDIDOS: '); readln (totalEVendidos);
		end;
		writeln ('');
	end;
end;

procedure imprimirMaestro (c:cMaestro);
begin
	with c do begin
		writeln ('FECHA: ',fecha,' |CODIGO SUCURSAL: ',cod,' |NOMBRE SUCURSAL: ',nombre,' |PRECIO: ',precio:2:2,' |TOTAL EJEMPLARES: ',totalE);
		writeln ('TOTAL EJEMPLARES VENDIDOS: ',totalEVendidos);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with c do begin 
		write ('INGRESE FECHA: '); readln (fecha);
		if (fecha <> ' ') then begin
			write ('INGRESE CODIGO SUCURSAL: '); readln (cod);
			write ('INGRESE CANTIDAD VENDIDOS: '); readln (cantV);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (c:cDetalle);
begin
	with c do begin
		writeln ('FECHA: ',fecha,' |CODIGO SUCURSAL: ',cod,' |CANTIDAD VENDIDOS: ',cantV);
		writeln ('');
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
p:cMaestro;
begin
	rewrite (arc_maestro);
	leerMaestro (p);
	while (p.fecha <> ' ') do begin
		write (arc_maestro,p);
		leerMaestro(p);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
d:cDetalle;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.fecha <> ' ') do begin
		write (arc_detalle,d);
		leerDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
p:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,p);
		imprimirMaestro(p);
	end;
	close (arc_maestro);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:cDetalle;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimirDet(d);
	end;
	close (arc_detalle);
end;

var
arc_maestro: maestro;
aString: string;
i:integer;
deta:arDet;
begin
	Assign (arc_maestro,'maestro');
	writeln ('MAESTRO: ');
	{crearMaestro(arc_maestro);}
	mostrarMaestro (arc_maestro);
	for i:= 1 to n do begin
		writeln ('DETALLE ',i,' : ');
		Str (i,aString);
		Assign (deta[i],'detalle'+ aString);
		{crearDetalle (deta[i]);}
		mostrarDetalle (deta[i]);
	end;
end.

