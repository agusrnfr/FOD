{7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
*
NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}



program ejer7;
uses crt;

type
novela = record
	codigo: integer;
	precio: real;
	genero: string;
	nombre: string;
end;

archivo = file of novela;

procedure ingresarNombre (var nombre:string);
begin
	write ('INGRESE NOMBRE DEL ARCHIVO: '); readln (nombre);
	writeln ('')
end;

procedure leer (var n:novela);
begin
	with n do begin
		write ('INGRESE CODIGO: '); readln (codigo);
		write ('INGRESE PRECIO: '); readln (precio);
		write ('INGRESE GENERO: ');	readln (genero);
		write ('INGRESE NOMBRE: ');	readln (nombre);
	end;
	writeln ('');
end;

procedure imprimir (n:novela);
begin
	with n do begin
		writeln ('|CODIGO: ',codigo);
		writeln ('|PRECIO: ',precio:0:2);
		writeln ('|GENERO: ',genero);
		writeln ('|NOMBRE: ',nombre);
		writeln ('');
	end;
end;

procedure crear (var arc_log:archivo; var arcTxt: Text);
var
	n:novela;
begin
	rewrite (arc_log);
	reset (arcTxt);
	while not eof (arcTxt) do begin
		with n do begin
			readln (arcTxt,codigo,precio,genero);
			readln (arcTxt,nombre);
		end;
		write (arc_log,n);
	end;
	close (arc_Log);
	close (arcTxt);
end;

procedure agregar(var arc_log:archivo);
var
	n:novela;
begin
	reset (arc_log);
	writeln ('-AGREGAR NOVELA-');
	seek (arc_log,FileSize (arc_log));
	leer (n);
	write (arc_log,n);
	close (arc_log);
end;

procedure mostrarPantalla (var arc_log:archivo);
var
	n:novela;
begin
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,n);
		imprimir (n);
	end;
	close (arc_log);
end;

procedure modificarNovela (var n:novela);
var
	opcion:integer;

begin
	writeln ('SELECCIONE QUE DESEA MODIFICAR');
	writeln ('');
	writeln ('1) PRECIO');
	writeln ('');
	writeln ('2) GENERO');
	writeln ('');
	writeln ('3) NOMBRE');
	writeln ('');
	write ('OPCION ELEGIDA --> ');
	readln (opcion);
	writeln ('');
	case opcion of 
	1: 
		begin
			write ('INGRESE NUEVO PRECIO: '); readln (n.precio);
		end;
	2:
		begin
			write ('INGRESE NUEVO GENERO: '); readln (n.genero);
		end;
	3: 	
		begin
			write ('INGRESE NUEVO NOMBRE: '); readln (n.nombre);
		end
	else 
		writeln ('NO ES UNA OPCION VALIDA');
	end;
	writeln ('');
end;

procedure modificar (var arc_log:archivo);
var
	codigo:integer;
	ok: boolean;
	n:novela;
begin
	reset (arc_log);
	ok:= false;
	write ('INGRESE CODIGO DE LA NOVELA QUE DESEA MODIFICAR: '); readln (codigo);
	writeln ('');
	while not eof (arc_log) and not(ok) do begin
		read (arc_log,n);
		if (codigo = n.codigo) then begin
			ok:= true;
			modificarNovela (n);
			seek (arc_log,FilePos(arc_log)-1);
			write (arc_log,n);		
		end;
	end;
	if (ok) then 
		writeln ('NOVELA MODIFICADA CON EXITO')
	else
		writeln ('NO SE ENCONTRO NOVELA');
	close(arc_log);
end;

procedure menu (var arc_log:archivo; var arcTxt: Text; nombre:string);
var
	opcion:integer;
begin
	writeln ('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ',nombre);
	writeln ('');
	writeln ('1) CREAR ARCHIVO BINARIO');
	writeln ('');
	writeln ('2) MOSTRAR EN PANTALLA');
	writeln ('');
	writeln ('3) ANIADIR UNA NOVELA');
	writeln ('');
	writeln ('4) MODIFICAR NOVELA');
	writeln ('');
	writeln ('5) SALIR');
	writeln ('');
	write ('OPCION ELEGIDA --> ');
	readln (opcion);
	writeln ('');
	case opcion of 
	1:	crear (arc_log,arcTxt);
	2:  mostrarPantalla (arc_log);
	3:  agregar (arc_log);
	4:	modificar (arc_log);
	5: 	halt
	else
		writeln ('NO ES UNA OPCION CORRECTA');
	end;
end;

var
	arc_log: archivo;
	arcTxt : Text;
	nombre:string;
	loop: boolean;
	letra: char;
begin
	textcolor (red);
	loop:= true;
	ingresarNombre (nombre);
	Assign (arc_log,nombre);
	Assign (arcTxt,'novelas.txt');
	menu (arc_log,arcTxt,nombre);
	while (loop) do begin
		writeln ('');
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
				menu (arc_log,arcTxt,nombre);
		end;
	end;
end.	
