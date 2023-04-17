{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por
teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}



program ejer4;
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

procedure crear (var arc_log:archivo);
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

//AÑADIR EMPLEADO

procedure anadirEmpleado (var arc_log:archivo);
var
	e:emp;
begin
	seek (arc_log,fileSize (arc_log));
	leer (e);
	while (e.ap <> 'fin') do begin
		write (arc_log,e);
		leer (e);
	end;
	close (arc_log);
end;

//MODIFICAR EDAD EMPLEADO

procedure modificar (var arc_log: archivo; nro:integer);
var 
	e:emp;
	edad:integer;
	ok:boolean;
begin
	ok:= false;
	while not eof(arc_log) and not (ok) do begin
		read (arc_log,e);
		if (e.nro = nro) then begin
			ok:= true;
			write ('INGRESE LA EDAD ACTUALIZADA: '); readln (edad);
			e.edad := edad;
			seek (arc_log,filepos (arc_log)-1);
			write (arc_log,e);
		end;
	end;
	if (ok = false) then 
		writeln ('NO SE ENCONTRO NUMERO DE EMPLEADO') 
	else
		writeln ('SE MODIFICO CON EXITO');
	writeln ('');
	close (arc_log);
end;

procedure eliminar (var arc: archivo; nro:integer);
var 
	e:emp;
	ok:boolean;
	f:emp;
begin
	ok:= false;	
	reset(arc);
	if (fileSize(arc) <> 0) then begin
		seek (arc,FileSize(arc)-1);
		read (arc,f);
		seek (arc,0);
		while not eof(arc) and not (ok) do begin
			read (arc,e);
			if (e.nro = nro) then begin
				ok:= true;
				seek (arc,filepos (arc)-1);
				write (arc,f);
				seek (arc,FileSize(arc)-1);
				truncate(arc);
				writeln ('SE ELIMINO CON EXITO');
			end;
		end;
		if (ok = false) then 
			writeln ('NO SE ENCONTRO NUMERO DE EMPLEADO');
		writeln ('');
	end
	else
		writeln ('ARCHIVO VACIO');
	close(arc);
end;

//EXPORTAR ARCHIVO

procedure exportar (var  arc_log:archivo; var todos_emp: Text);
var
	e:emp;
begin
	reset (arc_log);
	rewrite (todos_emp);
	while not eof (arc_log) do begin
		read (arc_log,e);
		with e do writeln (todos_emp,'|NRO: ',nro:10,'|EDAD: ',edad:10,'|DNI: ',dni:10,'|APELLIDO: ',ap:10,'|NOMBRE: ',nom:10); 
	end;
	close (arc_log);
	close (todos_emp)
end;

//DNI 00
procedure dni00 (var arc_log:archivo;var sin_dni:Text);
var
	e:emp;
begin
	reset (arc_log);
	rewrite (sin_dni);
	while not eof (arc_log) do begin
		read (arc_log,e);
		if (e.DNI = '00') then
			with e do writeln (sin_dni,'|NRO: ',nro:10,'|EDAD: ',edad:10,'|DNI: ',dni:10,'|APELLIDO: ',ap:10,'|NOMBRE: ',nom:10); 
	end;
	close (arc_log);
	close (sin_dni);
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

procedure menu (var arc_log:archivo;var todos_emp,sin_dni:Text; nombre:string);
var
	opcion:integer;
	nro:integer;
begin
	writeln('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ',nombre);
	writeln ('');
	writeln ('1) CREAR EL ARCHIVO');
	writeln ('');
	writeln ('2) ABRIR EL ARCHIVO');
	writeln ('');
	writeln ('3) ANIADIR EMPLEADO');
	writeln ('');
	writeln ('4) MODIFICAR EDAD');
	writeln ('');
	writeln ('5) EXPORTAR CONTENIDO A "todos_empleados.txt"');
	writeln ('');
	writeln ('6) EXPORTAR A QUIENES NO TENGAN DNI A "faltaDNIEmpleado.txt"');
	writeln ('');
	writeln ('7) ELIMINAR EMPLEADO');
	writeln ('');
	writeln ('8) SALIR');
	writeln ('');
	write 	('OPCION ELEGIDA -->  ');
	readln (opcion);
	writeln ('');
	case opcion of
		1: 
		begin
			crear (arc_log);
		end;
		2: 
		begin
			reset (arc_log);
			seleccion2 (arc_log);
		end;
		3:
		begin
			reset (arc_log);
			anadirEmpleado(arc_log);
		end;
		4: 
		begin
			write ('INGRESE Nro DEL EMPLEADO DEL QUE DESEA MODIFICAL LA EDAD. INGRESE -1 PARA FINALIZAR: ');
			readln (nro);
			while (nro <> -1) do begin
				reset (arc_log);
				modificar (arc_log,nro);
				write ('INGRESE Nro DEL EMPLEADO DEL QUE DESEA MODIFICAL LA EDAD. INGRESE -1 PARA FINALIZAR: ');
				readln (nro);
			end;
		end;
		5:
		begin
			exportar(arc_log,todos_emp);
		end;
		6: 
		begin
			dni00(arc_log,sin_dni);
		end;
		7: begin 
			write ('INGRESE Nro DE EMPLEADO A ELIMINAR: '); readln (nro);
			while (nro <> -1) do begin
					eliminar (arc_log,nro);
					write ('INGRESE Nro DE EMPLEADO A ELIMINAR: '); readln (nro);
			end;
		end;
		8: halt;
		else writeln ('NO SE ENCUENTRA ESA OPCION');	
	end;
end;

//PROGRAMA PRINCIPAL 

var
	nombre:string;
	arc_log:archivo;
	letra:char;
	todos_emp,sin_dni: Text;
	loop:boolean;
begin
	loop:= true;
	textcolor(red);
	clrscr;
	ingresarNombre(nombre);
	Assign(arc_log, nombre);
	Assign(todos_emp,'todos_empleados.txt');
	Assign(sin_dni,'faltaDNIEmpleado.txt');
	menu (arc_log,todos_emp,sin_dni,nombre);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
			menu (arc_log,todos_emp,sin_dni,nombre);
		end;
	end;
end.
