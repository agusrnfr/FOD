{Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}



program ejer6;
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

procedure leer (var c:celu);
begin
	with c do begin
		write ('INGRESE CODIGO DEL CELULAR: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE PRECIO DEL CELULAR: '); readln (precio);
			write ('INGRESE MARCA DEL CELULAR: '); readln (marca);
			write ('INGRESE STOCK DISPONIBLE: '); readln (stockD);
			write ('INGRESE STOCK MINIMO: '); readln (stockM);
			write ('INGRESE DESCRIPCION: '); readln (des);
			write ('INGRESE NOMBRE DEL CELULAR: '); readln (nombre);
		end;
		writeln ('');
	end;
end;

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
begin//CUANDO LEO LA CADENA DEL TXT LE AGREGA UN ESPACIO AL INICIO.
	ok:= false;
	reset (arc_log);
	while not eof (arc_log) do begin
		read (arc_log,c);
		if (pos(cadena, c.des) > 0) then begin
			imprimir (c);
			ok := true;
		end;
	end;
	if (ok = false) then begin
	writeln ('NINGUN CELULAR TIENE ESA CADENA EN LA DESCRIPCION'); writeln ('');
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

procedure aniadir (var arc_log:archivo);
var
	c:celu;
begin
	reset (arc_log);
	seek (arc_log, fileSize (arc_log));
	leer (c);
	while (c.cod <> -1) do begin
		write (arc_log,c);
		leer (c);
	end;
	close (arc_log);
end;

procedure modificar (var arc_log:archivo);
var
	c:celu;
	nombre:string;
	stock:integer;
	esta:boolean;
begin
	esta:= false;
	reset (arc_log);
	write ('INGRESE NOMBRE DEL CELULAR A MODIFICAR STOCK: '); readln (nombre);
	writeln ('');
	while not eof (arc_log) and not(esta)do begin
		read (arc_log,c);
		if (c.nombre = nombre) then begin
			esta := true;
			write ('INGRESE NUEVO STOCK: '); readln (stock);
			writeln ('');
			c.stockD := stock;
			seek (arc_log,filePos (arc_log)-1);
			write (arc_log,c)
		end;
	end;
	if not(esta) then 
		writeln ('NO SE ENCONTRO EL CELULAR A MODIFICAR STOCK')
	else
		writeln ('MODIFICADO CON EXITO');
	writeln ('');
	close (arc_log)	
end;

procedure exportarNoStock (var arc_log:archivo; var noStock: Text);
var
	c:celu;
begin
	reset (arc_log);
	rewrite (noStock);
	while not eof (arc_log) do begin
		read (arc_log,c);
		if (c.stockD = 0) then begin
		with c do writeln (noStock,'|CODIGO: ',cod:10,' |PRECIO: ',precio:10:2,' |MARCA: ',marca:10,'|STOCK DISPONIBLE: ',stockD:10,' |STOCK MINIMO: ',stockM:10,
		'|DESCRIPCION:',des:10,' |NOMBRE: ',nombre:10);
		writeln ('EXPORTADO CON EXITO');
		end;
	end;
	close (arc_log);
	close (noStock);
end;


procedure menu (var arc_log:archivo; var carga,celu2,noStock:Text; nombre:string);
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
	writeln ('5) ANIADIR CELUAR');
	writeln ('');
	writeln ('6) MODIFICAR STOCK DE UN CELULAR DADO');
	writeln ('');
	writeln ('7) EXPORTAR A "SinStock.txt" AQUELLOS CELULAR SIN STOCK');
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
			write ('INGRESE CADENA A BUSCAR EN LA DESCRIPCION DE CELULAR: ');
			readln(cadena);
			writeln ('');
			buscarCadena(arc_log,cadena);
		end;
		4:	exportar (arc_log,celu2);
		5: 
		begin
			aniadir (arc_log);
		end;
		6: modificar (arc_log);
		7: exportarNoStock (arc_log,noStock);
		else writeln ('NO SE ENCUENTRA ESA OPCION');	
	end;
end;

var
	arc_log: archivo;
	carga,celu2,noStock: Text;
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
	Assign (noStock,'SinStock.txt');
	menu (arc_log,carga,celu2,noStock,nombre);
		while (loop) do begin
		writeln ('');
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
				menu (arc_log,carga,celu2,noStock,nombre);
		end;
	end;

end.
