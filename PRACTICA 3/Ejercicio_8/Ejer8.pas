{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución  cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}

program ejer8;

CONST
valorAlto = 'ZZZ';

type

linux = record
	nom:string[50];
	anio:string[10];
	num:string[5];
	cant:integer;
	des:string[50];
end;

archivo = file of linux;

procedure leerArc (var arc_log:archivo; var dato:linux);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.nom := valorAlto;
end;

procedure leer (var n:linux);
begin
	with n do begin
		write ('INGRESE NOMBRE: '); readln (nom);
		if (nom <> ' ') then begin
			write ('INGRESE ANIO: ');	readln (anio);
			write ('INGRESE NUMERO DE VERSION: ');	readln (num);
			write ('INGRESE CANTIDAD DE DESARROLLADORES: '); readln (cant);
			write ('INGRESE DESCRIPCION: '); readln (des);
		end;
	end;
	writeln ('');
end;

procedure imprimir (n:linux);
begin
	with n do begin
		if (cant > 0) then begin
			writeln ('|NOMBRE: ',nom,'|ANIO: ',anio,'|NUMERO VERSION: ',num,'|CANTIDAD DE DESARROLLADORES: ',cant,' |DESCRIPCION: ',des);
			writeln ('');
		end;
	end;
end;

procedure crear (var arc_log:archivo);
var
n:linux;
begin
	rewrite (arc_log);
	n.cant := 0;
	write (arc_log,n);
	leer (n);
	while (n.nom <> ' ') do begin
		write (arc_log,n);
		leer(n);
	end;
	close (arc_log);
end;

procedure mostrarPantalla (var arc_log:archivo);
var
	n:linux;
begin
	reset(arc_log);
	seek (arc_log,1);
	leerArc(arc_log,n);
	while (n.nom <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;

function ExisteDistribucion(nom:string; var arc_log:archivo):boolean;
var
n:linux;
ok:boolean;
begin
	reset(arc_log);
	leerArc(arc_log,n);
	ok:= false;
	while (n.nom <> valorAlto) and not(ok) do begin
		if (n.nom = nom) then 
			ok:= true;
		leerArc(arc_log,n);
	end;
	close(arc_log);
	ExisteDistribucion:= ok;
end;

procedure AltaDistribucion (var arc_log:archivo);
var
n,indice,r:linux;
begin
	leer (r); //leo el registro 
	if not (ExisteDistribucion(r.nom,arc_log)) then begin
		reset(arc_log);
		leerArc (arc_log,n);
		if (n.cant < 0) then begin
			seek (arc_log,abs(n.cant)); //voy a la posicion con espacio libre
			read (arc_log,indice); //leo el indice que esta en esa posicion y me lo guardo en la var indice
			seek (arc_log,filePos(arc_log)-1); //ubico el puntero
			write (arc_log,r); //escribo en la posicion donde habia espacio libre
			seek (arc_log,0); //vuelvo al registro cabecera 
			write (arc_log,indice); //escribo el indice que tenia almacenado en la posicion que acabo de dar de alta 
		end
		else
			writeln ('NO HAY ESPACIO LIBRE');
		close(arc_log);
	end
	else
		writeln ('YA EXISTE DISTRIBUCION');
end;

procedure BajaDistribucion (var arc_log:archivo);
var
n,indice:linux;
nom:string[50];
ok:boolean;
begin
	ok:= false;
	write ('INGRESE NOMBRE DE LA DISTRIBUCION QUE DESEA ELIMINAR: '); readln (nom);
	writeln ('');
	if (ExisteDistribucion(nom,arc_log)) then begin
		reset(arc_log);
		leerArc(arc_log,indice); //leo el indice que esta en el cabecera
		leerArc (arc_log,n);
		while (n.nom <> valorAlto) and not(ok) do begin
			if (n.nom = nom) then begin
				ok:= true;
				n.cant:= indice.cant; //copio el indice que estaba en el reg 0 en el que elimino para tener la lista invertida
				seek (arc_log,filePos(arc_log)-1);
				indice.cant:= filePos(arc_log) * -1; //paso el indice a negativo
				write(arc_log,n);
				seek(arc_log,0);
				write(arc_log,indice); //el indice que esta en el registro cabecera lo remplazo con el del reg que acabo de eliminar
			end
			else
				leerArc (arc_log,n);
		end;
		close(arc_log);
		writeln ('DISTRIBUCION ELIMINADA');
	end
		else
		writeln ('DISTRIBUCION NO EXISTENTE');
end;

var
arc_log:archivo;
begin
	Assign (arc_log,'archivo.dot');
	writeln ('CREAR');
	crear(arc_log);
	mostrarPantalla(arc_log);
	writeln ('BAJA');
	writeln ('');
	BajaDistribucion(arc_log);
	writeln ('');
	writeln ('ALTA');
	writeln ('');
	AltaDistribucion(arc_log);
	writeln ('');
	mostrarPantalla(arc_log);
end.
