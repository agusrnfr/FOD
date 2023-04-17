program ejer6;

CONST
valorAlto = 9999;

type
prendas = record
	cod:integer;
	des:string[50];
	tipo:string[50];
	stock:integer;
	precio:real;
end;

archivo = file of prendas;

procedure leerArc (var arc_log:archivo; var dato:prendas);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.cod := valorAlto;
end;

procedure leer (var p:prendas);
begin
	with p do begin
		write ('INGRESE CODIGO: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE STOCK: '); readln (stock);
			write ('INGRESE PRECIO: ');readln (precio);
		end;
		writeln ('');
	end;
end;

procedure leer2 (var p:prendas);
begin
	with p do begin
		write ('INGRESE CODIGO: '); readln (cod);
	end;
end;

procedure imprimir (p:prendas);
begin
	with p do begin
		writeln ('CODIGO: ',cod,' STOCK: ',stock,' PRECIO: ',precio:1:1);
		writeln (' ');
	end;
end;

procedure imprimir2 (p:prendas);
begin
	with p do begin
		writeln ('CODIGO: ',cod);
		writeln (' ');
	end;
end;

procedure actualizar (var arc:archivo; var det:archivo);
var
p,o:prendas;
begin
	reset(arc);
	reset(det);
	while(not eof(det)) do begin
		read(det,o);
		read(arc,p);
		while (o.cod <> p.cod) do begin
			read(arc,p);
		end;
		seek(arc,filePos(arc)-1);
		p.cod:= p.cod * -1;
		write(arc,p);
		seek(arc,0);
	end;
	close(arc);
	close(det);
end;

procedure crear (var arc_log:archivo);
var
n:prendas;
begin
	rewrite (arc_log);
	leer (n);
	while (n.cod <> -1) do begin
		write (arc_log,n);
		leer(n);
	end;
	close (arc_log);
end;

procedure crear2 (var arc_log:archivo);
var
n:prendas;
begin
	rewrite (arc_log);
	leer2 (n);
	while (n.cod <> -1) do begin
		write (arc_log,n);
		leer2(n);
	end;
	close (arc_log);
end;

procedure mostrar (var arc_log:archivo);
var
n:prendas;
begin
	reset (arc_log);
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close (arc_log);
end;
procedure mostrar2 (var arc_log:archivo);
var
n:prendas;
begin
	reset (arc_log);
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		imprimir2 (n);
		leerArc(arc_log,n);
	end;
	close (arc_log);
end;

procedure compactar (var arc,nuevo:archivo);
var
p:prendas;
begin	
	rewrite(nuevo);
	reset(arc);
	while(not eof(arc))do begin
		read(arc,p);
		if (p.cod >= 0) then
			write(nuevo,p);
	end;
	close(nuevo);
	close(arc);
end;

var
arc_log,aEliminar,arch_nuevo: archivo;
begin
	Assign (arc_log,'maestro.dot');
	Assign (aEliminar,'detalle.dot');
	Assign (arch_nuevo,'arch_aux.dot');
	writeln ('CREAR ARCHIVO MAESTRO');
	writeln ('');
	crear (arc_log);
	writeln ('CREAR DETALLE');
	writeln ('');
	crear2(aEliminar);
	writeln ('MAESTRO');
	writeln ('');
	mostrar (arc_log);
	writeln ('DETALLE');
	writeln ('');
	mostrar2(aEliminar);
	actualizar (arc_log,aEliminar);
	compactar (arc_log,arch_nuevo);
	erase (arc_log);
	rename(arch_nuevo,'maestro.dot');
	writeln('NUEVO MAESTRO');
	writeln ('');
	mostrar(arch_nuevo);
end.

