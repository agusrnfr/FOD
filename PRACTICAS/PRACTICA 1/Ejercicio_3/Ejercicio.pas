{Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.}

program ejer3;
uses crt;

type

emp = record
	nro: integer;
	ap: string[50];
	nom:string[50];
	edad:integer;
	DNI:string;
end;

archivo = file of emp;

//INGRESAR NOMBRE DE ARCHIVO

procedure ingresarNombre (var nombre:string);
begin
	write ('INGRESE NOMBRE DEL ARCHIVO: '); readln (nombre);
	writeln ('')
end;

// LEER REGISTRO

procedure leer (var e:emp);
begin
	with e do begin
		write ('INGRESE APELLIDO DE EMPLEADO: '); readln (ap);
		if (ap <> 'fin') then begin
			write ('INGRESE NOMBRE DE EMPLEADO: '); readln (nom);
			write ('INGRESE NRO DE EMPLEADO: '); readln (nro);
			write ('INGRESE EDAD DE EMPLEADO: '); readln (edad);
			write ('INGRESE DNI DE EMPLEADO: '); readln (dni);
		end;
		writeln ('')
	end;
end;

//IMPRIMIR REGISTRO

procedure imprimir (e: emp);
begin
	with e do begin
		writeln ('NRO: ',nro);
		writeln ('APELLIDO: ',ap);
		writeln ('NOMBRE: ',nom);
		writeln ('EDAD: ',edad);
		writeln ('DNI: ',dni);
		writeln ('');
	end;
end;

//CREAR ARCHIVO

procedure crear (var arc_log:archivo; nombre:string);
var
	e:emp;
begin
	rewrite (arc_log);
	leer (e);
	while (e.ap <> 'fin') do begin
		write (arc_log,e);
		leer (e);
	end;
	close (arc_log);
end;

//OPCION A

procedure mostrarPantallaNomDetermiando (var arc_log: archivo);
var
	nom: string[50];
	e: emp;
begin
	write ('INGRESE NOMBRE O APELLIDO DETERMINADO: '); 
	readln (nom);
	while not eof (arc_log) do begin
		read (arc_log,e);
		if (e.ap = nom) or (e.nom = nom) then begin
			imprimir (e)
		end;	
	end;
	close (arc_log);
end;

//OPCION B
procedure mostrarDeAUno (var arc_log:archivo);
var
	e:emp;
begin
	while not eof(arc_log) do begin
		read (arc_log,e);
		imprimir (e);
	end;
	close (arc_log);
end;

//OPCION C
procedure mostrarMayores (var arc_log:archivo);
var
	e:emp;
begin
	while not eof (arc_log) do begin
		read (arc_log,e);
		if (e.edad > 70) then begin
			imprimir (e);
		end;
	end;
	close (arc_log);
end;


//MENU

procedure seleccion2 (var arc_log:archivo);
var
	opcion:char;
begin
	writeln('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ABIERTO');
	writeln ('');
	writeln('a. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.');
	writeln('b. Listar en pantalla los empleados de a uno por linea.');
	writeln('c. Listar en pantalla empleados mayores de 70 anos, proximos a jubilarse.');
	writeln ('');
	write 	('OPCION ELEGIDA -->  ');
	readln (opcion);
	writeln ('');
	case opcion of
		'a': mostrarPantallaNomDetermiando (arc_log);
		'b': mostrarDeAUno (arc_log);
		'c': mostrarMayores (arc_log);
		else writeln ('NO SE ENCUENTRA ESA OPCION');
	end;
end;

procedure menu (var arc_log:archivo; nombre:string);
var
	opcion:integer;
begin
	writeln('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ',nombre);
	writeln ('');
	writeln ('1) CREAR EL ARCHIVO');
	writeln ('');
	writeln ('2) ABRIR EL ARCHIVO');
	writeln ('');
	write 	('OPCION ELEGIDA -->  ');
	readln (opcion);
	writeln ('');
	case opcion of
		1: 
		begin
			crear (arc_log,nombre);
		end;
		2: 
		begin
			reset (arc_log);
			seleccion2 (arc_log);
		end;
		else writeln ('NO SE ENCUENTRA ESA OPCION');	
	end;
end;

//PROGRAMA PRINCIPAL 

var
	nombre:string;
	arc_log:archivo;
	letra: char;
	loop:boolean;
begin
	loop:= true;
	textcolor(red);
	clrscr;
	ingresarNombre(nombre);
	Assign(arc_log, nombre);
	menu (arc_log,nombre);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
			menu (arc_log,nombre);
		end;
	end;
end.
