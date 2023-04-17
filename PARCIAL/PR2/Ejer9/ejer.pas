program ejer9;

CONST
valorAlto = 9999;

type
mesa = record
	prov:integer;
	loc:integer;
	nro:integer;
	cant:integer;
end;

archivo = file of mesa;

procedure leer (var arc:archivo; var m:mesa);
begin
	if not eof (arc) then
		read (arc,m)
	else
		m.prov := valorAlto;
end;

procedure contabilizar (var arc:archivo);
var
m:mesa;
provActual,locActual,sumVotos,sumProv,total : integer;
begin
	reset (arc);
	leer (arc,m);
	total:= 0;
	while (m.prov <> valorAlto) do begin
		sumProv:= 0;
		provActual:= m.prov;
		writeln ('|CODIGO PROVINCIA: ',provActual);
		writeln ('|CODIGO LOCALIDAD	 |TOTAL DE VOTOS');
		while (m.prov = provActual) do begin
			locActual:= m.loc;
			sumVotos:=0;
			while (m.prov = provActual) and (m.loc = locActual) do begin
				sumVotos += m.cant;
				leer (arc,m);
			end;
			writeln (' ',locActual,'			 ',sumVotos);
			sumProv+= sumVotos;
		end;
		writeln ('|TOTAL DE VOTOS DE PROVINCIA: ',sumProv);
		writeln ('');
		writeln ('');
		total+= sumProv;
	end;
	writeln ('......................................');
	writeln ('TOTAL GENERAL DE VOTOS: ',total);
	close (arc);
end;

var
arc:archivo;

begin
	Assign (arc,'maestro');
	contabilizar (arc);
end.
