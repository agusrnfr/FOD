program ejer_7;

CONST 
valorAlto = 9999;

type 

mas = record
	cod:integer;
	nom:string;
	precio:real;
	stockA:integer;
	stockM:integer;
end;


det = record
	cod:integer;
	cant:integer;
end;

maestro = file of mas;
detalle = file of det;

procedure leer(var arc:detalle; var d:det);
begin
	if (not eof (arc)) then
		read(arc,d)
	else
		d.cod := valorAlto;
end;

procedure actualizar (var arc_m:maestro; var arc_d:detalle);
var
m:mas;
d:det;
cant,act:integer;
begin
	reset(arc_m);
	reset(arc_d);
	leer(arc_d,d);
	while(d.cod <> valorAlto) do begin
		act:= d.cod;
		cant:= 0;
		while (d.cod = act) do begin
			cant += d.cant;
			leer(arc_d,d);
		end;
		read(arc_m,m);
		while(m.cod <> act) do 
			read(arc_m,m);
		m.stockA-=cant;
		seek(arc_m,filePos(arc_m)-1);
		write(arc_m,m);
	end;
	close(arc_m);
	close(arc_d);
end;

procedure exportar(var arc:maestro; var arcTxt: Text);
var
m:mas;
begin
	reset(arc);
	rewrite(arcTxt);
	while not eof (arc) do begin
		read(arc,m);
		if (m.stockA < m.stockM) then begin
			with m do begin
				writeln(arcTxt,cod,' ',nom,' ',precio,' ',stockA,' ',stockM);
			end;
		end;
	end;
	close(arc);
	close(arcTxt);
end;

var
arc_m:maestro;
arc_d:detalle;
arcTxt:text;

begin
	Assign (arc_m,'maestro');
	Assign (arc_d,'detalle');
	Assign (arcTxt,'stock_minimo.txt');
	actualizar(arc_m,arc_d);
	exportar(arc_m,arcTxt);
end.
