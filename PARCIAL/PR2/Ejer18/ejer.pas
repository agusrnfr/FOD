program ejer18;

CONST 
valorAlto = 9999;

type
hospital = record
	codl:integer;
	noml:string[25];
	codm:integer;
	nomm:string[25];
	codh:integer;
	nomh:string[25];
	fecha:string[8];
	cant:integer;
end;

archivo = file of hospital;

procedure leer (var arc:archivo; var h:hospital);
begin
	if (not eof (arc)) then
		read (arc,h)
	else
		h.codl:= valorAlto;
end;

procedure mostrar (var arc:archivo);
var
h:hospital;
locActual,muniActual,hosActual,casosLoc,casosMuni,casosHos,totalProv:integer;

begin
	reset(arc);
	totalProv:= 0;
	leer(arc,h);
	while (h.codl <> valorAlto) do begin
		locActual:= h.codl;
		casosLoc:= 0;
		writeln ('NOMBRE LOCALIDAD ',locActual,' : ',h.noml);
		while (h.codl = locActual) do begin
			muniActual:= h.codm;
			casosMuni:= 0;
			writeln ('  NOMBRE MUNICIPIO ',muniActual,' : ',h.nomm);
			while (h.codl = locActual) and (h.codm = muniActual) do begin
				hosActual:= h.codh;
				casosHos:= 0;
				writeln ('   NOMBRE HOSPITAL ',hosActual,' : ',h.nomh,'.....................................CANTIDAD CASOS HOSPITAL ',hosActual);
				while (h.codl = locActual) and (h.codm = muniActual) and (h.codh = hosActual) do begin
					casosHos+= h.cant;
					leer (arc,h);
				end;
				writeln ('     ',casosHos);
				casosMuni+=casosHos;
			end;
			writeln ('  CANTIDAD CASOS MUNICIPIO ',muniActual);
			writeln ('  ',casosMuni);
			casosLoc+= casosMuni;
		end;
		writeln ('CANTIDAD CASOS LOCALIDAD ',locActual);
		writeln (casosLoc);
		writeln ('');
		totalProv+=casosLoc;
	end;
	writeln ('CANTIDAD DE CASOS TOTALES EN LA PROVINCIA ');
	writeln (totalProv);
	close(arc);
end;

var
arc:archivo;
begin
	Assign (arc,'maestro');
	mostrar(arc);
end.
