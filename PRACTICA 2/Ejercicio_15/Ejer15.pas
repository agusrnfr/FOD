{15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización se debe proceder de la siguiente manera:
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}

program ejer15;
uses crt;

CONST 
valorAlto = 9999;
n = 3;

type

cMaestro = record
	codP:integer;
	nomP:string;
	codL:integer;
	nomL:string;
	vSinL:integer;
	vSinG:integer;
	vDeC:integer;
	vSinA:integer;
	vSinS:integer;
end;

cDetalle = record
	codP:integer;
	codL:integer;
	vConL:integer;
	vConG:integer;
	vConst:integer;
	vConA:integer;
	vEntregaS:integer;
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
		dato.codP := valorAlto;
end;

procedure minimo (var deta:arDet; var min:cDetalle; var registro:regDet);
var
i,indiceMin:integer;
begin
	indiceMin:= 0;
	min.codP:= valorAlto;
	for i:= 1 to n do 
		if (registro[i].codP <> valorAlto) then
			if ((registro[i].codP < min.codP) or ((registro[i].codP = min.codP) and (registro[i].codL < min.codL))) then begin
				min:= registro[i];
				indiceMin:= i;
			end;
	if (indiceMin <> 0) then
		leer(deta[indiceMin],registro[indiceMin]);
end;

procedure actualizar (var arc_maestro:maestro);
var
deta: arDet;
registro: regDet;
m:cMaestro;
i,totalConL,totalConG,totalConst,totalConA,totalEntregaS,codPActual,codLActual:integer;
aString:string;
min:cDetalle;
begin
	reset (arc_maestro);
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+aString);
		reset (deta[i]);
		leer (deta[i],registro[i]);
	end;
	minimo (deta,min,registro);
	while (min.codP <> valorAlto) do begin
		codPActual:= min.codP;
		while (min.codP = codPActual) do begin
			codLActual:= min.codL;
			totalConL:=0;
			totalConG:=0;
			totalConst:=0;
			totalConA:=0;
			totalEntregaS:=0;
			while (min.codP = codPActual) and (min.codL = codLActual) do begin 
				totalConL+=min.vConL;										   
				totalConG+=min.vConG;
				totalConst+=min.vConst;
				totalConA+=min.vConA;
				totalEntregaS+=min.vEntregaS;
				minimo (deta,min,registro);
			end;
			read (arc_maestro,m);
			while (m.codP <> codPActual) or (m.codL <> codLActual) do begin
				read (arc_maestro,m);
			end;
			
			m.vSinL-= totalConL;
			m.vSinG-= totalConG;
			m.vDeC-=totalConst;
			m.vSinA-=totalConA;
			m.vSinS-=totalEntregaS;
			
			seek (arc_maestro,filePos (arc_maestro)-1);
			write (arc_maestro,m);		
		end;	
	end;
	for i:=1 to n do
		close (deta[i]);
	close (arc_maestro);
end;

var
arc_maestro:maestro;
cant:integer;
m:cMaestro;

begin
	cant:= 0;
	Assign (arc_maestro,'maestro');
	actualizar (arc_maestro);
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		if (m.vDeC = 0) then
				cant+= 1;
	end;
	writeln ('CANTIDAD DE LOCALIDADES SIN VIVIENDAS DE CHAPA: ',cant);
end.
