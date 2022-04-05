{17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.
* NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.}

program ejer17;

CONST
valorAlto = 9999;
n= 3;

type

cMaestro = record
	cod:integer;
	nom:string[25];
	des:string[100];
	mode:string[25];
	marca:string[25];
	stock:integer;
end;

cDetalle = record
	cod:integer;
	fecha:string[8];
	precio:real;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;
regDet = array [1..n] of cDetalle;

procedure leer (var arc_detalle:detalle; var dato:cDetalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.cod := valorAlto;
end;

procedure minimo (var deta:arDet; var min:cDetalle; var registro:regDet);
var
i,indiceMin:integer;
begin
	indiceMin:= 0;
	min.cod:= valorAlto;
	for i:= 1 to n do 
		if (registro[i].cod <> valorAlto) then
			if (registro[i].cod < min.cod) then begin
				min:= registro[i];
				indiceMin:= i;
			end;
	if (indiceMin <> 0) then
		leer(deta[indiceMin],registro[indiceMin]);
end;

procedure maxMoto (total:integer;moto:cMaestro; var max:integer; var maxM:cMaestro);
begin
	if (total > max) then begin
		max:= total;
		maxM:= moto;
	end;
end;

procedure actualizar (var arc_maestro:maestro);
var
deta: arDet;
registro: regDet;
m,maxM:cMaestro;
i,max,codActual,totalV:integer;
aString:string;
min:cDetalle;
begin
	max:= -1;
	reset (arc_maestro);
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+aString);
		reset (deta[i]);
		leer (deta[i],registro[i]);
	end;
	minimo (deta,min,registro);
 	while (min.cod <> valorAlto) do begin
		codActual:= min.cod;
		totalV:= 0;
		while (min.cod = codActual) do begin
			totalV+= 1;
			minimo (deta,min,registro);
		end;
		read (arc_maestro,m);
		while (codActual <> m.cod) do begin
			read (arc_maestro,m);
		end;
		
		m.stock-= totalV;
		maxMoto (totalV,m,max,maxM);
		
		seek (arc_maestro,filePos(arc_maestro)-1);
		write (arc_maestro,m);
 	end;
	writeln ('LA MOTO MAS VENDIDA FUE: ');
	writeln ('COD: ',maxM.cod,' NOMBRE: ',maxM.nom,' MODELO: ',maxM.mode,' MARCA: ',maxM.marca);
	for i:=1 to n do
		close (deta[i]);
	close (arc_maestro);
end;

var
arc_maestro:maestro;

begin
	Assign (arc_maestro,'maestro');
	actualizar (arc_maestro);
end.
