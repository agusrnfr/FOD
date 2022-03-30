{6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle. se suma
2. Idem anterior para los recuperados. se suma
3. Los casos activos se actualizan con el valor recibido en el detalle. se actualiza
4. Idem anterior para los casos nuevos hallados. se actualiza
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

program ejer6;
uses crt;

CONST
valorAlto = 9999;
n = 3;

type

cMaestro = record
	cod: integer;
	nombre: string;
	cepa: integer;
	nombreC: string;
	cAc: integer;
	cNue: integer;
	cRec: integer;
	cF: integer;
end;

cDetalle = record
	cod: integer;
	cepa: integer;
	cAc: integer;
	cNue:integer;
	cRec:integer;
	cF:integer;
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
		dato.cod:= valorAlto;
end;

procedure leerMaestro (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.cod:= valorAlto;
end;

procedure minimo (var registro:regDet; var min:cDetalle; var deta:arDet);
var
indiceMin,i:integer;
begin
	min.cod := valorAlto;
	indiceMin:= 0;
	for i:= 1 to n do 
	if (registro[i].cod <> valorAlto) then begin
			if (registro[i].cod < min.cod) then begin
					min:= registro[i];
					indiceMin:= i;
			end
			else
			if (registro[i].cod = min.cod)and (registro[i].cepa < min.cepa)then begin
				min:= registro[i];
				indiceMin:= i;
			end;
	end;
	if (indiceMin <> 0) then 
		leer (deta[indiceMin],registro[indiceMin]);
end;

procedure actualizarMaestro (var arc_maestro:maestro);
var
aString:string;
deta: arDet;
registro: regDet;
min:cDetalle;
m:cMaestro;
i,codActual,cepaActual,totalFallecidos,totalRecuperados,activos,nuevos:integer;
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
		while (codActual = min.cod) do begin
			cepaActual:= min.cepa;
			totalFallecidos:= 0;
			totalRecuperados:= 0;
			while (codActual = min.cod) and (cepaActual = min.cepa) do begin     
				totalFallecidos+= min.cF;
				totalRecuperados+= min.cRec;
				activos:= min.cAc;
				nuevos:= min.cNue;
				minimo (registro,min,deta);
			end;
			read (arc_maestro,m);
			while (m.cod <> codActual) do
				read (arc_maestro,m);
			while (m.cepa <> cepaActual) do
				read (arc_maestro,m);
			
			m.cF+= totalFallecidos;
			m.cRec+= totalRecuperados;
			m.cAc:= activos;
			m.cNue:= nuevos;
			
			seek (arc_maestro,filePos (arc_maestro)-1);
			write (arc_maestro,m);
		end;
	end;
	for i:=1 to n do
		close (deta[i]);
	close (arc_maestro);
end;

procedure recorrerMaestro (var arc_maestro:maestro);
var
p:cMaestro;
codActual,totalActivos:integer;
begin
	reset (arc_maestro);
	leerMaestro (arc_maestro,p);
	while (p.cod <> valorAlto) do begin
		codActual:= p.cod;
		totalActivos:= 0;
		while (p.cod = codActual) do begin
			totalActivos:= totalActivos + p.cAc;
			leerMaestro(arc_maestro,p);
		end;
		if (totalActivos > 50) then 
			writeln ('LA LOCALIDAD DE ',p.nombre,' TIENE MAS DE 50 CASOS ACTIVO CON UN TOTAL DE: ',totalActivos);
	end;
	close (arc_maestro);
end;

var
arc_maestro: maestro;

begin
	Assign (arc_maestro,'maestro');
	actualizarMaestro (arc_maestro);
	recorrerMaestro (arc_maestro);
end.
