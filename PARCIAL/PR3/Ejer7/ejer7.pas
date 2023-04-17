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

procedure eliminarArc (var arc:archivo; codigo:integer);
var
a:ave;
ok:boolean;
begin
	reset(arc);
	ok:= false;
	writeln ('');
	while (not eof (arc)) and not(ok) do begin
		read(arc,a);
		if (a.cod = codigo) then begin
			a.cod := a.cod * -1;
			seek(arc,filePos(arc)-1);
			write (arc,a);
			ok:=true;
			writeln ('AVE ELIMINADA')
		end;
	end;
	if (not ok) then 
		writeln ('NO SE ENCONTRO AVE');
	writeln('');
	close(arc);
end;

procedure compactar (var arc:archivo);
var
a:ave;
pos:integer;
begin
	reset(arc);
	leerArc(arc,a);
	while (a.cod <> valorAlto) do begin
		if (a.cod < 0) then begin
			pos:= (filePos(arc)-1);
			seek(arc,fileSize(arc)-1);
			leerArc(arc,a);
			while (a.cod <> valorAlto) and (a.cod < 0) do begin
				writeln (a.cod);
				seek(arc,fileSize(arc)-1);
				truncate(arc);
				if (fileSize (arc) <> 0) then begin
					seek(arc,fileSize(arc)-1);
				end;
				leerArc(arc,a);
			end;
			if (a.cod <> valorAlto) then begin
				seek(arc,pos);
				write(arc,a);
				seek(arc,fileSize(arc)-1);
				truncate(arc);
				seek(arc,pos);
			end;
		end;
		leerArc(arc,a);
	end;
	close(arc);
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
