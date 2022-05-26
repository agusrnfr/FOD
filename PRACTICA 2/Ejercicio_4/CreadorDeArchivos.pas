program creadorArchivos;
uses crt;

CONST
n = 2;

type

date =record
	dia:integer;
	mes:integer;
	anio:integer;
end;

rec = record
	cod:integer;
	fecha:date;
	tiempo:real;
end;

maestro = file of rec;
detalle = file of rec;
ar_detalle = array [1..n] of detalle;

procedure imprimir (r:rec);
begin
	with r do begin
		writeln ('CODIGO: ',cod);
		writeln ('FECHA: ',fecha.dia,'/', fecha.mes, '/', fecha.anio);
		writeln ('TIEMPO TOTAL DE SESIONES ABIERTAS: ',tiempo:0:2);
	end;
end;

procedure leer (var r:rec);
begin
	with r do begin
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE DIA: '); readln (fecha.dia);
			write ('INGRESE MES: '); readln (fecha.mes);
			write ('INGRESE ANIO: '); readln (fecha.anio);
			write ('INGRESE TIEMPO DE SESION: '); readln (tiempo);
		end;
		writeln ('');
	end;
end;


procedure crearDetalle (var arc_detalle:detalle);
var
d:rec;
begin
	rewrite (arc_detalle);
	leer (d);
	while (d.cod <> -1) do begin
		write (arc_detalle,d);
		leer(d);
	end;
	close (arc_detalle);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:rec;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimir(d);
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
		crearDetalle (deta[i]);
		mostrarDetalle (deta[i]);
	end;
end.
