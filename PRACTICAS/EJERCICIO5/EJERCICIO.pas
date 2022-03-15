{Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo.}



program ejer5;
uses crt;

type

celu = record
	cod:integer;
	precio:real;
	marca:string;
	stockD:integer;
	stockM:integer;
	des:string;
	nombre:string;
end;

archivo = file of celu;

//INGRESAR NOMBRE DE ARCHIVO

procedure ingresarNombre (var nombre:string);
begin
	write ('INGRESE NOMBRE DEL ARCHIVO: '); readln (nombre);
	writeln ('')
end;

procedure crear (var arc_log:archivo; var carga:Text);
var
	c:celu;
begin
	reset (carga);
	rewrite (arc_log);
	while not eof (carga) do begin
		with c do begin 
		readln (carga, cod, precio, marca);
		readln (carga,stockD,stockM ,des);
		readln (carga,nombre); 
		end;
		write (arc_log,c);
	end;
	writeln ('ARCHIVO CARGADO');
	writeln ('');
	close (carga);
	close (arc_log);
end;

procedure menu (var arc_log:archivo; var carga:Text; nombre:string);
var
	opcion:integer;
begin
	writeln('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ',nombre);
	writeln ('');
	writeln ('1) CREAR EL ARCHIVO BINARIO CON LOS DATOS DE "celulares.txt"');
	writeln ('');
	writeln ('2) MOSTRAR EN PANTALLA LOS DATOS DE LOS CELULARES CON STOCK MENOR AL STOCK MINIMO');
	writeln ('');
	writeln ('3) MOSTRAR EN PANTALLA CELULARES CUYA DESCRIPCION TENGA UNA CADENAS DE CARACTERES PROPORCIONADA POR EL USUARIO');
	write 	('OPCION ELEGIDA -->  ');
	readln (opcion);
	writeln ('');
	case opcion of
		1: 
		begin
			crear (arc_log,carga);
		end
		else writeln ('NO SE ENCUENTRA ESA OPCION');	
	end;
end;

var
	arc_log: archivo;
	carga: Text;
	nombre:string;
	letra:char;
	loop:boolean;

begin
	loop:= true;
	textcolor(red);
	clrscr;
	ingresarNombre (nombre);
	Assign (arc_log,nombre);
	Assign (carga,'celulares.txt');
	menu (arc_log,carga,nombre);
		while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
				menu (arc_log,carga,nombre);
		end;
	end;

end.