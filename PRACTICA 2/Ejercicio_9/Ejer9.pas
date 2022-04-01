{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación: }


program ejer9;

CONST
valorAlto = 9999;

type
cMaestro = record
	codP:integer;
	codL:integer;
	nro:integer;
	cantV:integer;
end;

maestro = file of cMaestro;

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.codP:= valorAlto;
end;

procedure listado (var arc_maestro: maestro);
var
m:cMaestro;
totalProvincia,totalLocalidad,total:integer;
provActual,locActual:integer;
begin
	reset (arc_maestro);
	leer (arc_maestro,m);
	total:= 0;
	while (m.codP <> valorAlto) do begin
		provActual:= m.codP;
		totalProvincia:= 0;
		writeln ('|CODIGO PROVINCIA');
		writeln (' ',m.codP);
		writeln ('|CODIGO LOCALIDAD	|TOTAL DE VOTOS');
		while (m.codP = provActual) do begin
			locActual:= m.codL;
			totalLocalidad:= 0;
			while (m.codP = provActual) and (m.codL = locActual) do begin
				totalLocalidad:= totalLocalidad + m.cantV;
				leer (arc_maestro,m);
			end;
			writeln (' ',locActual,'			 ',totalLocalidad);
			totalProvincia:= totalProvincia + totalLocalidad;
		end;
		writeln ('|TOTAL DE VOTOS DE PROVINCIA: ',totalProvincia);
		writeln ('');
		writeln ('');
		total+= totalProvincia;
	end;
	writeln ('......................................');
	writeln ('TOTAL GENERAL DE VOTOS: ',total);
end;

var
arc_maestro:maestro;

begin
	Assign (arc_maestro,'maestro');
	listado (arc_maestro);
end.
