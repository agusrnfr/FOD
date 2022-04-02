{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ejer11;

CONST
valorAlto = 'ZZZZ';

type
cMaestro = record
	nombre:string;
	cant:integer;
	encu:integer;
end;


cDetalle = record
	nombre:string;
	cod:integer;
	cant:integer;
	encu:integer;
end;

maestro = file of cMaestro;

detalle = file of cDetalle;

procedure leer (var arc_det: detalle; var dato: cDetalle);
begin
	if not eof (arc_det) then
		read (arc_det,dato)
	else
		dato.nombre:= valorAlto;
end;

procedure minimo (var r1,r2: cDetalle; var min:cDetalle; var det1,det2:detalle);
 begin
   if (r1.nombre <= r2.nombre) then begin
       min := r1;
       leer(det1,r1);
   end
    else begin
		min := r2; 
		leer(det2,r2);
	end;
end;

procedure actualizar (var arc_maestro:maestro; var det1,det2: detalle);
var
m:cMaestro;
min,regD1,regD2:cDetalle;
totalAl,totalEn:integer;
nomActual: string;
begin
	reset (arc_maestro);
	reset (det1);
	reset (det2);
	leer (det1,regD1); leer (det2,regD2);
	minimo (regD1,regD2,min,det1,det2);
	while (min.nombre <> valorAlto) do begin
		totalAl:= 0;
		totalEn:= 0;
		nomActual:= min.nombre;
		while (min.nombre = nomActual) do begin
			totalAl+= min.cant;
			totalEn+= min.encu;
			minimo (regD1,regD2,min,det1,det2);
		end;
		read (arc_maestro,m);
		while (nomActual <> m.nombre ) do 
			read (arc_maestro,m);
		seek (arc_maestro,filePos (arc_maestro)-1);
		m.cant+= totalAl;
		m.encu+=totalEn;
		write (arc_maestro,m);
	end;
	close (arc_maestro);
	close (det1);
	close (det2);
end;


var
arc_maestro:maestro;
det1,det2:detalle;

begin
	Assign (arc_maestro,'maestro');
	Assign (det1,'detalle1');
	Assign (det2,'detalle2');
	actualizar (arc_maestro,det1,det2);
end.
