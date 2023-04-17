{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program ejer2;

CONST
valorAlto = 9999;

type

asistente = record
	AyN: string[50];
	nro:integer;
	mail:string[50];
	telefono:string;
	dni:string[8];
end;

archivo = file of asistente;

procedure leer (var a:asistente);
begin
	with a do begin 
		write ('INGRESE NRO: '); readln (nro);
		if (nro <> -1) then begin
			write ('INGRESE APELLIDO Y NOMBRE: '); readln (AyN);
			write ('INGRESE MAIL: '); readln (mail);
			write ('INGRESE TELEFONO: '); readln (telefono);
			write ('INGRESE DNI: '); readln (dni);
		end;
		writeln ('');
	end;
end;

procedure imprimir (a:asistente);
begin
	with a do begin
		if (AyN <> '@Eliminado') then begin
			writeln ('NRO: ',nro,' APELLIDO Y NOMBRE: ',AyN,' MAIL: ',mail,' TELEFONO: ',telefono,' DNI: ',dni);
			writeln ('');
		end;
	end;
end;

procedure mostrarArc (var arc_log:archivo);
var
a:asistente;
begin
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,a);
		imprimir(a);
	end;
	close (arc_log);
end;

procedure crear (var arc_log:archivo);
var
a:asistente;
begin
	rewrite (arc_log);
	leer (a);
	while (a.nro <> -1) do begin
		write (arc_log,a);
		leer(a);
	end;
	close (arc_log);
end;

procedure eliminar (var arc_log:archivo);
var
a:asistente;
begin
	reset(arc_log);
	while (not eof (arc_log)) do begin
		read(arc_log,a);
		if (a.nro < 1000) then begin
			a.AyN:= '@Eliminado';
			seek (arc_log,filePos(arc_log)-1);
			write(arc_log,a);
		end;
	end;
	close(arc_log);
end;

var
arc_log:archivo;

begin
	Assign (arc_log,'archivo.dot');
	//crear(arc_log);
	eliminar (arc_log);
	mostrarArc(arc_log);
end.
