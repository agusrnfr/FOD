{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
* a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos. --> si hay una diferencia de +5 entre final y cursada.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
* }

program ejer2;

CONST
valorAlto = 9999;

type

rango = 0..1;

alumno = record
	cod:integer;
	apellido:string;
	nombre:string;
	cantMsin: integer;
	cantMcon: integer;
end;

materia = record
	cod: integer;
	fin:rango; //0 desaprobado 1 aprobado
	curs:rango; //0 desaprobado 1 aprobado
end;

maestro = file of alumno;
detalle = file of materia;

procedure leer (var arc_detalle: detalle; var dato: materia);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
	dato.cod:= valorAlto;
end;

procedure leerAl (var a:alumno);
begin
	with a do begin
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE APELLIDO: '); readln (apellido);
			write ('INGRESE NOMBRE: '); readln (nombre);
			write ('INGRESE CANTIDAD MATERIAS SIN FINAL: '); readln (cantMsin);
			write ('INGRESE CANTIDAD DE MATERIAS CON FINAL: '); readln (cantMcon);
		end;
		writeln ('');
	end;
end;

procedure imprimirAl (a:alumno);
begin
	with a do begin
		writeln ('CODIGO: ',cod);
		writeln ('APELLIDO: ',apellido);
		writeln ('NOMBRE: ',nombre);
		writeln ('SIN FINAL: ',cantMsin);
		writeln ('CON FINAL: ',cantMcon);
	end;
end;

procedure leerDet (var d:materia);
begin
	with d do begin
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE SI APROBO CURSADA: '); readln (curs);
			write ('INGRESE SI APROBO FINAL: '); readln (fin);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (d:materia);
begin
	with d do begin
		writeln ('CODIGO: ',cod);
		writeln ('CURSADA: ',curs);
		writeln ('FINAL: ',fin); 
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
a:alumno;
begin
	rewrite (arc_maestro);
	leerAl (a);
	while (a.cod <> -1) do begin
		write (arc_maestro,a);
		leerAl(a);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
d:materia;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.cod <> -1) do begin
		write (arc_detalle,d);
		leerDet(d);
	end;
	close (arc_detalle);
end;

procedure actualizar (var arc_maestro: maestro; var arc_detalle: detalle);
var
m:materia;
a:alumno;
aux:integer;
cantC,cantM:integer;

begin
	reset (arc_maestro);
	reset (arc_detalle);
	leer (arc_detalle,m);
	while (m.cod <> valorAlto) do begin
		aux:= m.cod; cantC:= 0; cantM := 0;
		while (m.cod = aux) do begin
			if (m.curs <> 0) then
				cantC+=1;
			if (m.fin <> 0) then
				cantM+=1;
			leer (arc_detalle,m);
		end;
		read(arc_maestro,a);
		while (a.cod <> aux) do
			read (arc_maestro,a);
		a.cantMsin+=cantC;
		a.cantMcon+=cantM;
		seek (arc_maestro,filePos (arc_maestro)-1);
		write (arc_maestro,a);
	end;
	close (arc_maestro);
	close (arc_detalle);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:materia;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimirDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
a:alumno;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,a);
		imprimirAl(a);
	end;
	close (arc_maestro);
end;

procedure pasarATxt (var arc_maestro:maestro; var arcTxt:Text);
var
a:alumno;
begin
	reset (arc_maestro);
	rewrite (arcTxt);
	while not eof (arc_maestro) do begin
		read (arc_maestro,a);
		if (a.cantMsin - a.cantMcon > 4) then
		with a do begin
			writeln (arcTxt,cod,'  ',apellido,'  ',nombre,'  ',cantMsin,'  ',cantMcon);
		end;
	end;
	close (arc_maestro);
	close (arcTxt);
end;

var
arc_maestro:maestro;
arc_detalle:detalle;
arcTxt: Text;
begin
	Assign (arc_maestro,'maestro');
	Assign (arc_detalle,'detalle');
	Assign (arcTxt,'alumnos.txt');
	crearMaestro(arc_maestro);
	writeln ('');
	crearDetalle(arc_detalle);
	writeln ('');
	mostrarMaestro (arc_maestro);
	writeln ('');
	mostrarDetalle (arc_detalle);
	actualizar (arc_maestro,arc_detalle);
	writeln ('');
	mostrarMaestro (arc_maestro);
	pasarATxt (arc_maestro,arcTxt);
end.
