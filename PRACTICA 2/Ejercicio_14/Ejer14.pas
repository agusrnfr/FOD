{14. Una compañía aérea dispone de un archivo maestro donde guarda información sobre
sus próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida
y la cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
c. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
d. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}

program ejer14;

CONST
valorAlto = 'ZZZZ';

type
cMaestro = record
destino:string;
fecha:string;
hora:string;
cantAs:integer;
end;

cDetalle = record
destino:string;
fecha:string;
hora:string;
cantAs:integer;
end;

lista = ^nodo;

nodo = record
	dato:cMaestro;
	sig:lista;
end;


maestro = file of cMaestro; //pueden ser el mismo registro no me di cuenta y me da paja cambiarlo :c
detalle = file of cDetalle;

procedure imprimirMaestro (c:cMaestro);
begin
	with c do begin
		writeln ('DESTINO: ',destino,' FECHA: ',fecha,' HORA: ',hora,' CANTIDAD ASIENTOS: ',cantAs);
		writeln ('');
	end;
end;

procedure leer (var arc_det: detalle; var dato: cDetalle);
begin
	if not eof (arc_det) then
		read (arc_det,dato)
	else
		dato.destino:= valorAlto;
end;

procedure minimo (var r1,r2: cDetalle; var min:cDetalle; var det1,det2:detalle);
 begin
   if (r1.destino < r2.destino) or ((r1.destino = r2.destino) and (r1.fecha < r2.fecha)) or ((r1.destino = r2.destino) and (r1.fecha = r2.fecha) and (r1.hora < r2.hora)) then begin
       min := r1;
       leer(det1,r1);
   end
   {else
	if (r1.destino = r2.destino) and (r1.fecha < r2.fecha) then begin
	   min := r1;
       leer(det1,r1);
    end
    else 
		if (r1.destino = r2.destino) and (r1.fecha = r2.fecha) and (r1.hora < r2.hora) then begin
			min := r1;
			leer(det1,r1);
		end}
    else begin
		min := r2; 
		leer(det2,r2);
	end;
end;

procedure agregarAlFinal (var p,pUlt:lista; m:cMaestro);
var
nuevo:lista;
begin
	new (nuevo); nuevo^.dato:= m; nuevo^.sig:= nil;
	if (p = nil) then
		p:= nuevo
	else
		pUlt^.sig := nuevo;
	pUlt:= nuevo;
end;

procedure actualizar (var arc_maestro:maestro; var det1,det2: detalle; var p:lista; cant:integer);
var
m:cMaestro;
min,regD1,regD2:cDetalle;
totalAs:integer;
desActual,fecActual,horaActual: string;
pUlt:lista;
begin
	reset (arc_maestro);
	reset (det1);
	reset (det2);
	leer (det1,regD1); leer (det2,regD2);
	minimo (regD1,regD2,min,det1,det2);
	while (min.destino <> valorAlto) do begin
		desActual:= min.destino;
		while (min.destino = desActual) do begin
			fecActual:= min.fecha;
			while (min.destino = desActual) and (min.fecha = fecActual) do begin
				horaActual := min.hora;
				totalAs:= 0;
				while (min.destino = desActual) and (min.fecha = fecActual) and (min.hora = horaActual) do begin
					totalAs+= min.cantAs;
					minimo (regD1,regD2,min,det1,det2);
				end;
				read (arc_maestro,m);
				while (desActual <> m.destino) or (fecActual <> m.fecha) or (horaActual <> m.hora) do begin
					read(arc_maestro,m);
				end;
				seek (arc_maestro,filePos (arc_maestro)-1);
				m.cantAs-= totalAs;
				write (arc_maestro,m);
				if (m.cantAs < cant) then
					agregarAlFinal (p,pUlt,m);
				end;
		end;
	end;
	close (arc_maestro);
	close (det1);
	close (det2);
end;

procedure imprimirLista (p:lista);
begin
	while (p <> nil) do begin
		imprimirMaestro (p^.dato);
		p:= p^.sig;
	end;
end;


var
arc_maestro:maestro;
det1,det2:detalle;
p: lista;
cant:integer;

begin
	p:= nil;
	Assign (arc_maestro,'maestro');
	Assign (det1,'detalle1');
	Assign (det2,'detalle2');
	write ('INGRESE UNA CANTIDAD DE ASIENTOS: '); readln (cant);
	actualizar (arc_maestro,det1,det2,p,cant);
	imprimirLista (p)
end.

