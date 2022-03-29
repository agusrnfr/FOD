program creadorArchivos;
uses crt;

CONST
n = 2;

type

suc = record
	cod_usuario:integer;
	fecha:string;
	tiempo_sesion:real;
end;

producto = record
	cod_usuario: integer;
	fecha:string;
	tiempo_total_de_sesiones_abiertas: real;
end;

maestro = file of producto;
detalle = file of suc;
ar_detalle = array [1..n] of detalle;

procedure imprimirPr (p:producto);
begin
	with p do begin
		writeln ('CODIGO: ',cod_usuario);
		writeln ('FECHA: ',fecha);
		writeln ('TIEMPO TOTAL DE SESIONES ABIERTAS: ',tiempo_total_de_sesiones_abiertas);
		writeln ('');
	end;
end;

procedure leerDet (var d:suc);
begin
	with d do begin
		write ('INGRESE COD: '); readln (cod_usuario);
		if (cod_usuario <> -1) then begin
			write ('INGRESE FECHA: '); readln (fecha);
			write ('INGRESE TIEMPO DE SESION: '); readln (tiempo_sesion);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (d:suc);
begin
	with d do begin
		writeln ('CODIGO: ',cod_usuario);
		writeln ('FECHA: ',fecha);
		writeln ('TIEMPO DE SESION: ',tiempo_sesion);
		writeln ('');
	end;
end;


procedure crearDetalle (var arc_detalle:detalle);
var
d:suc;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.cod_usuario <> -1) do begin
		write (arc_detalle,d);
		leerDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:suc;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimirDet(d);
	end;
	close (arc_detalle);
end;

var
arc_maestro: maestro;
aString: string;
i:integer;
deta:ar_detalle;

begin
	Assign (arc_maestro,'maestro');
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+ aString);
		crearDetalle (deta[i])
		{mostrarDetalle (deta[i]);}
	end;
end.

