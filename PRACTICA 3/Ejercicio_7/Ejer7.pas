{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}

program ejer7;

CONST 
valorAlto = 9999;

type
ave = record
	cod:integer;
	nom:string[50];
	fam:string[50];
	des:string[50];
	zona:string[50];
end;

archivo = file of ave;

procedure leer (var a:ave);
begin
	with a do begin
		write ('INGRESE CODIGO AVE: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE NOMBRE DE AVE: '); readln (nom);
			write ('INGRESE FAMILIA DE AVE: '); readln (fam);
			write ('INGRESE DESCRIPCION: '); readln (des);
			write ('INGRESE ZONA: '); readln (zona);
		end;
		writeln ('')
	end;
end;

procedure imprimir (a:ave);
begin
	with a do begin
		writeln ('CODIGO: ',cod,' NOMBRE: ',nom,' FAMILIA: ',fam,' ZONA: ',zona);
		writeln (' ');
	end;
end;

procedure leerArc (var arc_log:archivo; var dato:ave);
begin
	if not eof (arc_log) then
		read (arc_log,dato)
	else
		dato.cod := valorAlto;
end;

procedure crear (var arc_log:archivo);
var
n:ave;
begin
	rewrite (arc_log);
	leer (n);
	while (n.cod <> -1) do begin
		write (arc_log,n);
		leer(n);
	end;
	close (arc_log);
end;

procedure mostrar (var arc_log:archivo);
var
n:ave;
begin
	reset (arc_log);
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		imprimir (n);
		leerArc(arc_log,n);
	end;
	close (arc_log);
end;

procedure eliminarArc (var arc_log:archivo; codigo:integer);
var
n:ave;
ok:boolean;
begin
	reset(arc_log);
	ok:= false;
	writeln ('');
	leerArc (arc_log,n);
	while (n.cod <> valorAlto) and not(ok) do begin
		if (n.cod = codigo) then begin
			n.nom := '@Eliminado';
			seek(arc_log,filePos(arc_log)-1);
			write (arc_log,n);
			ok:=true;
		end
		else
			leerArc (arc_log,n);
	end;
	if (ok) then 
		writeln ('AVE ELIMINADA')
	else
		writeln ('NO SE ENCONTRO AVE');
	writeln('');
	close(arc_log);
end;

procedure compactar (var arc_log:archivo);
var
n:ave;
pos:integer;
begin
	reset(arc_log);
	leerArc(arc_log,n);
	while (n.cod <> valorAlto) do begin
		if (n.nom = '@Eliminado') then begin
			pos:= (filePos(arc_log)-1);
			seek(arc_log,fileSize(arc_log)-1);
			read(arc_log,n);
			while (n.nom = '@Eliminado') do begin
				seek(arc_log,fileSize(arc_log)-1);
				truncate(arc_log);
				seek(arc_log,fileSize(arc_log)-1);
				read(arc_log,n);
			end;
			seek(arc_log,pos);
			write(arc_log,n);
			seek(arc_log,fileSize(arc_log)-1);
			truncate(arc_log);
			seek(arc_log,pos);
		end;
		leerArc(arc_log,n);
	end;
	close(arc_log);
end;

procedure baja (var arc_log:archivo);
var
codigo:integer;
begin
	write ('INGRESE CODIGO DEL AVE QUE DESEA ELIMINAR: '); readln (codigo);
	while (codigo <> 5000) do begin
		eliminarArc(arc_log,codigo);
		write ('INGRESE CODIGO DEL AVE QUE DESEA ELIMINAR: '); readln (codigo);
	end;
	compactar(arc_log);
end;

var
arc_log:archivo;

begin
	Assign (arc_log,'archivo');
	//crear(arc_log);
	mostrar(arc_log);
	baja (arc_log);
	mostrar(arc_log);
end.
