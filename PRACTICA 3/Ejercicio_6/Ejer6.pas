{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas}

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

procedure eliminar (var arc_log:archivo; codigo:integer);
var
n:prendas;
begin
	reset (arc_log);
	leerArc(arc_log,n);
	while (n.cod <> codigo) do //se supone que todas las prendas existen en el maestro.
		leerArc (arc_log,n);
	seek (arc_log,filePos(arc_log)-1);
	n.stock:= n.stock * -1;
	write (arc_log,n);
	close (arc_log);
end;

procedure actualizar (var arc_log,aEliminar:archivo);
var
n:prendas;
begin
	reset (aEliminar);
	leerArc (aEliminar,n);
	while (n.cod <> valorAlto) do begin
		eliminar (arc_log,n.cod);
		leerArc(aEliminar,n);
	end;
	close (aEliminar);
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

procedure compactar (var arc_log,aux:archivo);
var
n:prendas;
begin	
	reset(arc_log);
	rewrite(aux);
	leerArc(arc_log,n);
	while(n.cod <> valorAlto) do begin
		if (n.stock >= 0) then begin
			write (aux,n);
		end;
		leerArc(arc_log,n);
	end;
	close (arc_log);
	close(aux);
end;

var
arc_log,aEliminar,arch_nuevo: archivo;
begin
	Assign (arc_log,'maestro.dot');
	Assign (aEliminar,'detalle.dot');
	Assign (arch_nuevo,'arch_aux.dot');
	{writeln ('CREAR ARCHIVO MAESTRO');
	writeln ('');
	crear (arc_log);
	writeln ('CREAR DETALLE');
	writeln ('');
	crear2(aEliminar);}
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
