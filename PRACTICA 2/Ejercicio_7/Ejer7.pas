{7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program ejer7;
uses crt;

CONST

valorAlto = 9999;
n = 2;

type

cMaestro = record
	cod: integer;
	nombre:string;
	precio: real;
	stockA: integer;
	stockM: integer;
end;

cDetalle = record
	cod: integer;
	cantV: integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;
regDet = array [1..n] of cDetalle;

procedure leer (var arc_Det: detalle; var data: cDetalle);
begin
	if not eof (arc_Det) then
		read (arc_Det,data)
	else
	data.cod:= valorAlto;
end;

procedure minimo (var registro: regDet; var min:cDetalle; var arc_det: arDet);
var
minIndice,i: integer;
begin
	min.cod:= valorAlto;
	minIndice:= 0;
	for i:= 1 to n do
		if (registro[i].cod <> valorAlto) then
			if (registro[i].cod < min.cod) then begin
				min:= registro[i];
				minIndice:= i;
			end;
	if (minIndice <> 0) then
		leer (arc_det[minIndice],registro[minIndice]);
end;

procedure actualizar (var arc_maestro:maestro);
var
registro: regDet;
min:cDetalle;
deta: arDet;
cantidadV,i,codActual: integer;
aString: string;
m:cMaestro;
begin
	reset (arc_maestro);
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+aString);
		reset (deta[i]);
		leer (deta[i],registro[i]);
	end;
	minimo (registro,min,deta);
	while (min.cod <> valorAlto) do begin
		codActual:= min.cod;
		cantidadV:= 0;
		while (min.cod = codActual) do begin
			cantidadV:= cantidadV + min.cantV;
			minimo(registro,min,deta);
		end;
		read (arc_maestro,m);
		while (m.cod <> codActual) do begin
			read (arc_maestro,m);
		end;
		seek (arc_maestro,filePos (arc_maestro)-1);
		m.stockA:= m.stockA - cantidadV;
		write (arc_maestro,m);
	end;
	close (arc_maestro);
	for i := 1 to n do
		close (deta[i]);
end;

procedure hacerTxt (var arc_maestro:maestro; var arcTxt: Text);
var
p:cMaestro;
begin
	reset (arc_maestro);
	rewrite (arcTxt);
	while not eof (arc_maestro) do begin
		read (arc_maestro,p);
		if (p.stockA < p.stockM) then
			with p do begin
				writeln (arcTxt,cod,'  ',nombre,'  ',precio:1:1,'  ',stockA,'  ',stockM);
			end;
	end;
	close (arc_maestro);
	close (arcTxt);
end;


var
arc_maestro: maestro;
arcTxt: Text;

begin
	Assign (arc_maestro,'maestro');
	Assign (arcTxt,'menorStock.txt');
	actualizar (arc_maestro);
	hacerTxt (arc_maestro,arcTxt);
end.
