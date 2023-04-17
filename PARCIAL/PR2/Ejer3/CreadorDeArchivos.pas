program creadorArchivos;
uses crt;

CONST
n = 3;

type

producto = record
	cod: integer;
	nombre: string;
	des: string;
	stockD: integer;
	stockM: integer;
	precio:real;
end;

suc = record
	cod:integer;
	cantidadVendida:integer; //stock vendido hago stockD - cantVendida
end;

maestro = file of producto;
detalle = file of suc;
ar_detalle = array [1..n] of detalle;


procedure leerProducto (var p: producto);
begin
	with p do begin 
		write ('INGRESE CODIGO: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE NOMBRE: '); readln (nombre);
			write ('INGRESE STOCK DISPONIBLE: '); readln (stockD);
			write ('INGRESE STOCK MINIMO: '); readln (stockM);
			write ('INGRESE PRECIO: '); readln (precio);
		end;
		writeln ('');
	end;
end;

procedure imprimirPr (p:producto);
begin
	with p do begin
		writeln ('CODIGO: ',cod);
		writeln ('NOMBRE: ',nombre);
		writeln ('STOCK DISPONIBLE ',stockD);
		writeln ('STOCK MINIMO: ',stockM);
		writeln ('PRECIO: ',precio:1:1);
		writeln ('');
	end;
end;

procedure leerDet (var d:suc);
begin
	with d do begin
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE CANTIDAD VENDIDA: '); readln (cantidadVendida);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (d:suc);
begin
	with d do begin
		writeln ('CODIGO: ',cod);
		writeln ('CANTIDAD VENDIDA: ',cantidadVendida);
		writeln ('');
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
p:producto;
begin
	rewrite (arc_maestro);
	leerProducto (p);
	while (p.cod <> -1) do begin
		write (arc_maestro,p);
		leerProducto(p);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
d:suc;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.cod <> -1) do begin
		write (arc_detalle,d);
		leerDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
p:producto;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,p);
		imprimirPr(p);
	end;
	close (arc_maestro);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:suc;
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
deta:ar_detalle;

begin
	Assign (arc_maestro,'maestro');
	//crearMaestro(arc_maestro);
	mostrarMaestro (arc_maestro);
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+ aString);
		//crearDetalle (deta[i])
		//mostrarDetalle (deta[i]);
	end;
end.
