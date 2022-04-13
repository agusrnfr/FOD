{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
(Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descripta anteriormente)
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado}
program ejer4;

CONST
valorAlto = 9999;

type

reg_flor = record
nombre: String[45];
codigo:integer;
end;

tArchFlores = file of reg_flor;

procedure leerArc (var arc_log:tArchFlores; var dato:reg_flor);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.codigo := valorAlto;
end;

procedure leer (var n: reg_flor);
begin
	with n do begin
		write ('INGRESE CODIGO: '); readln(codigo);
		if (codigo <> -1) then begin
			write ('INGRESE NOMBRE: '); readln(nombre);
			end;
		writeln (' ');
	end;
end;

procedure crear (var arc_log:tArchFlores);
var
n:reg_flor;
begin
	rewrite (arc_log);
	n.codigo := 0;
	n.nombre:= 'Cabecera';
	write (arc_log,n);
	leer (n);
	while (n.codigo <> -1) do begin
		write (arc_log,n);
		leer(n);
	end;
	close (arc_log);
end;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
indice:reg_flor;
n:reg_flor;
begin
	reset (a);
	leerArc (a,n); //LEO REGISTRO CABECERA
	if (n.codigo < 0) then begin
		seek (a,abs(n.codigo));
		read (a,indice);
		seek (a,filePos(a)-1);
		n.nombre := nombre;
		n.codigo:= codigo;
		write (a,n);
		seek (a,0);
		write (a,indice);
		writeln ('FLOR AGREGADA CON EXITO');
	end
	else
		writeln ('NO HAY ESPACIO LIBRE');
	close(a);
end;

procedure eliminarFlor (var arc_log:tArchFlores);
var
n,indice:reg_flor;
codigo:integer;
ok:boolean;
begin
	reset (arc_log);
	ok:= false;
	write ('INGRESE CODIGO DE LA FLOR QUE DESEA ELIMINAR: '); readln (codigo);
	writeln ('');
	leerArc(arc_log,indice); //leo el indice que esta en el cabecera
	leerArc (arc_log,n);
	while (n.codigo <> valorAlto) and not(ok) do begin
		if (n.codigo = codigo) then begin
			ok:= true;
			n.codigo:= indice.codigo; //copio el indice que estaba en el reg 0 en el que elimino para tener la lista invertida
			seek (arc_log,filePos(arc_log)-1);
			indice.codigo:= filePos(arc_log) * -1; //paso el indice a negativo
			write(arc_log,n);
			seek(arc_log,0);
			write(arc_log,indice); //el indice que esta en el registro cabecera lo remplazo con el del reg que acabo de eliminar
		end
		else
			leerArc (arc_log,n);
	end;
	if (ok) then 
		writeln ('FLOR ELIMINADA')
	else
		writeln ('NO SE ENCONTRO FLOR');
	close (arc_log);
end;

procedure imprimir (n:reg_flor);
begin
	with n do begin
			if (codigo > 0) then begin
			writeln ('|CODIGO: ',codigo,' NOMBRE: ',nombre);
			writeln ('');
		end;
	end;
end;

procedure mostrarPantalla (var arc_log:tArchFlores);
var
	n:reg_flor;
begin
	reset (arc_log);
	seek (arc_log,1);
	leerArc(arc_log,n);
	while (n.codigo <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close (arc_log);
end;

var
arc_log: tArchFlores;
nombre:string[45];
codigo:integer;

begin
	Assign (arc_log,'archivo.dot');
	writeln ('CREAR');
	crear (arc_log);
	writeln (' ');
	
	writeln ('ELIMINAR');
	eliminarFlor(arc_log);
	writeln (' ');
	
	writeln ('AGREGAR');
	write ('INGRESE CODIGO: '); readln(codigo);
	write ('INGRESE NOMBRE: '); readln (nombre);
	writeln (' ');
	agregarFlor(arc_log,nombre,codigo);
	writeln (' ');
	
	writeln ('LISTAR EN PANTALLA');
	mostrarPantalla(arc_log)
end.
