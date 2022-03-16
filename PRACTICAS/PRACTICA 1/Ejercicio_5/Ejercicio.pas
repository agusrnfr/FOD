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

procedure imprimir (c:celu);
begin
	with c do begin
		writeln ('|CODIGO: ',cod,' |PRECIO: ',precio:0:2,' |MARCA: ',marca);
		writeln ('|STOCK DISPONIBLE: ',stockD,' |STOCK MINIMO: ',stockM);
		writeln ('|DESCRIPCION:',des,' |NOMBRE: ',nombre);
		writeln ('');
	end;
end;

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

procedure menosStockMinimo (var arc_log:archivo);
var
	c:celu;
begin
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,c);
		if (c.stockD < c.stockM) then begin
			imprimir (c);
		end;
	end;
	close (arc_log);
end;

procedure buscarCadena (var arc_log:archivo; cadena:string);
var
	c:celu;
	ok:boolean;
begin
	cadena:= ' ' + cadena; //CUANDO LEO LA CADENA DEL TXT LE AGREGA UN ESPACIO AL INICIO.
	ok:= false;
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,c);
		if (c.des = cadena) then begin
			imprimir (c);
			ok := true;
		end;
	end;
	if (ok = false) then begin
	writeln ('NINGUN CELULAR TIENE ESA DESCRIPCION'); writeln ('');
	end;
	close (arc_log);
end;

procedure exportar (var arc_log:archivo; var celu2:Text);
var
	c:celu;
begin
	rewrite (celu2);
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,c);
		with c do begin
		writeln (celu2,'|CODIGO: ',cod:10,' |PRECIO: ',precio:10:2,' |MARCA: ',marca:10,'|STOCK DISPONIBLE: ',stockD:10,' |STOCK MINIMO: ',stockM:10,
		'|DESCRIPCION:',des:10,' |NOMBRE: ',nombre:10);
		end;
	end;
	writeln ('SE EXPORTO CON EXITO');
	close (arc_log);
	close (celu2);
end;

procedure menu (var arc_log:archivo; var carga,celu2:Text; nombre:string);
var
	opcion:integer;
	cadena:string;
begin
	writeln('INGRESE POR TECLADO LA OPCION QUE DESEA REALIZAR CON EL ARCHIVO ',nombre);
	writeln ('');
	writeln ('1) CREAR EL ARCHIVO BINARIO CON LOS DATOS DE "celulares.txt"');
	writeln ('');
	writeln ('2) MOSTRAR EN PANTALLA LOS DATOS DE LOS CELULARES CON STOCK MENOR AL STOCK MINIMO');
	writeln ('');
	writeln ('3) MOSTRAR EN PANTALLA CELULARES CUYA DESCRIPCION TENGA UNA CADENAS DE CARACTERES PROPORCIONADA POR EL USUARIO');
	writeln ('');
	writeln ('4) EXPORTAR ARCHIVO A "celulares2.txt"');
	writeln ('');
	write 	('OPCION ELEGIDA -->  ');
	readln (opcion);
	writeln ('');
	case opcion of
		1: 
			crear (arc_log,carga);
		2:
			menosStockMinimo (arc_log);
		3: 
		begin
			write ('INGRESE DESCRIPCION DE CELULAR BUSCAR: ');
			readln(cadena);
			writeln ('');
			buscarCadena(arc_log,cadena);
		end;
		4:	exportar (arc_log,celu2);
		else writeln ('NO SE ENCUENTRA ESA OPCION');	
	end;
end;

var
	arc_log: archivo;
	carga,celu2: Text;
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
	Assign (celu2,'celulares2.txt');
	menu (arc_log,carga,celu2,nombre);
		while (loop) do begin
		writeln ('');
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
				menu (arc_log,carga,celu2,nombre);
		end;
	end;

end.
