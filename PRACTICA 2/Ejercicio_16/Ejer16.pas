{16. La editorial X, autora de diversos semanarios, posee un archivo maestro con la
información correspondiente a las diferentes emisiones de los mismos. De cada emisión se
registra: fecha, código de semanario, nombre del semanario, descripción, precio, total de
ejemplares y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo}
program ejer16;

CONST
valorAlto = 'ZZZZ';
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
regDet = array [1..n] of cDetalle;

procedure leer (var arc_detalle:detalle; var dato:cDetalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.fecha := valorAlto;
end;

procedure minimo (var deta:arDet; var min:cDetalle; var registro:regDet);
var
i,indiceMin:integer;
begin
	indiceMin:= 0;
	min.fecha:= valorAlto;
	for i:= 1 to n do 
		if (registro[i].fecha <> valorAlto) then
			if ((registro[i].fecha < min.fecha) or ((registro[i].fecha = min.fecha) and (registro[i].cod < min.cod))) then begin
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
i,cantidadVentas,codActual:integer;
aString,fechaActual:string;
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
	while (min.fecha <> valorAlto) do begin
		fechaActual:= min.fecha;
		while (min.fecha = fechaActual) do begin
			codActual:= min.cod;
			cantidadVentas:= 0;
			while (min.fecha = fechaActual) and (min.cod = codActual) do begin
				cantidadVentas+= min.cantV;
				minimo (deta,min,registro);
			end;
			read (arc_maestro,m);
			while (m.fecha <> fechaActual) or (m.cod <> codActual) do begin
				read (arc_maestro,m);
			end;
			
			m.totalE-=cantidadVentas;
			m.totalEVendidos+=cantidadVentas;
			
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
m:cMaestro;
min,max:cMaestro;

begin
	min.totalEVendidos:= 9999;
	max.totalEVendidos:=-1;
	Assign (arc_maestro,'maestro');
	actualizar (arc_maestro);
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		if (m.totalEVendidos < min.totalEVendidos) then
			min:=m;
		if (m.totalEVendidos > max.totalEVendidos) then
			max:=m;
	end;
	close (arc_maestro);
	writeln ('MINIMO: ',min.fecha,' ',min.cod);
	writeln ('MAXIMO: ',max.fecha,' ',max.cod);
end.
