{3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}


program ejer3;
uses crt;

CONST
valorAlto = 9999;
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
reg_detalle = array [1..n] of suc;

procedure leer (var arc_detalle: detalle; var dato:suc);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.cod:= valorAlto;
end;

procedure minimo (var registro:reg_detalle; var min:suc ; var deta: ar_detalle);
var 
i,indiceMin: integer;
begin
	indiceMin:= 0;
	min.cod:= valorAlto;
	for i:= 1 to n do
		if (registro[i].cod < min.cod ) then begin
			min:= registro[i];
			indiceMin:= i;
		end;
	if (indiceMin <> 0) then begin
		leer(deta[indiceMin], registro[indiceMin]);	
	end;
end;

procedure actualizar (var arc_maestro:maestro; var deta:ar_detalle);
var
min: suc;
i:integer;
m:producto;
cantVendida:integer;
codActual:integer;
registro:reg_detalle;
begin
	reset (arc_maestro);
	for i:=1 to n do begin
		reset (deta[i]);
		leer (deta[i],registro[i]); //leo el primer registro de los 30 archivos y lo escribo en el array de registros
		writeln (registro[i].cod);
	end;
	minimo (registro,min,deta); //obtengo minimo
	while (min.cod <> valorAlto) do begin  //mientras ese minimo sea distinto a valor alto
		codActual:= min.cod; 
		cantVendida:= 0;
		while (min.cod = codActual) do begin //mientras el minimo sea el codigo actual
			cantVendida:= cantVendida + min.cantidadVendida;  //voy sumando las cantidades vendidas
			minimo (registro,min,deta); //busco otro minimo, si es el mismo el codigo va a seguir siendo el mismo al actual y se van a ir sumando
		end;
		read (arc_maestro,m);
		while(m.cod <> codActual)do begin  //busco el codigo de maestro para que coincida con el minimo
			read (arc_maestro,m);
		end;
		seek (arc_maestro,filePos (arc_maestro)-1); //ubico puntero
		m.stockD := m.stockD - cantVendida; //actualizo el stock
		write (arc_maestro,m); //actualizo maestro
	end;
	for i:=1 to n do
		close (deta[i]);
	close (arc_maestro);
end;

procedure hacerTxt (var arc_maestro:maestro; var arcTxt: Text);
var
p:producto;
begin
	reset (arc_maestro);
	rewrite (arcTxt);
	while not eof (arc_maestro) do begin
		read (arc_maestro,p);
		if (p.stockD < p.stockM) then
			with p do begin
				writeln (arcTxt,cod,'  ',nombre,'  ',des,'  ',stockD,'  ',stockM,'  ',precio);
			end;
	end;
	close (arc_maestro);
	close (arcTxt);
end;

var
arcTxt : Text;
deta: ar_detalle;
arc_maestro:maestro;
aString: string;
i:integer;
begin
	Assign (arc_maestro,'maestro');
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+ aString);
	end;
	Assign (arcTxt,'menosStock.txt');
	actualizar (arc_maestro,deta);
	hacerTxt (arc_maestro,arcTxt);
end.
