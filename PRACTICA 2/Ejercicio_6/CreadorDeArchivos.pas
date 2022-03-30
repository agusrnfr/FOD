program creadorArchivos;
uses crt;

CONST
n = 3;

type

cMaestro = record
	cod: integer;
	nombre: string;
	cepa: integer;
	nombreC: string;
	cAc: integer;
	cNue: integer;
	cRec: integer;
	cF: integer;
end;

cDetalle = record
	cod: integer;
	cepa: integer;
	cAc: integer;
	cNue:integer;
	cRec:integer;
	cF:integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;


procedure leerMaestro (var c: cMaestro);
begin
	with c do begin 
		write ('INGRESE CODIGO: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE NOMBRE MUNICIPIO: '); readln (nombre);
			write ('INGRESE CODIGO CEPA: '); readln (cepa);
			write ('INGRESE NOMBRE CEPA: '); readln (nombreC);
			write ('INGRESE CASOS ACTIVOS: '); readln (cAC);
			write ('INGRESE CASOS NUEVOS: '); readln (cNue);
			write ('INGRESE RECUPERADOS: '); readln (cRec);
			write ('INGRESE FALLECIDOS: '); readln (cF);
		end;
		writeln ('');
	end;
end;

procedure imprimirMaestro (c:cMaestro);
begin
	with c do begin
		writeln ('CODIGO MUNICIPIO: ',cod,' |NOMBRE MUNICIPIO: ',nombre,' |CODIGO CEPA: ',cepa,' |NOMBRE CEPA: ',nombreC);
		writeln ('CASOS ACTIVOS: ',cAC,' |CASOS NUEVOS: ',cNue,' |RECUPERADOS: ',cRec,' |FALLECIDOS: ',cF);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with c do begin
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE CODIGO CEPA: '); readln (cepa);
			write ('INGRESE CASOS ACTIVOS: '); readln (cAC);
			write ('INGRESE CASOS NUEVOS: '); readln (cNue);
			write ('INGRESE RECUPERADOS: '); readln (cRec);
			write ('INGRESE FALLECIDOS: '); readln (cF);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (c:cDetalle);
begin
	with c do begin
		writeln ('CODIGO MUNICIPIO: ',cod,'|CODIGO CEPA: ',cepa);
		writeln ('CASOS ACTIVOS: ',cAC,' |CASOS NUEVOS: ',cNue,' |RECUPERADOS: ',cRec,' |FALLECIDOS: ',cF);
		writeln ('');
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
p:cMaestro;
begin
	rewrite (arc_maestro);
	leerMaestro (p);
	while (p.cod <> -1) do begin
		write (arc_maestro,p);
		leerMaestro(p);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
d:cDetalle;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.cod <> -1) do begin
		write (arc_detalle,d);
		leerDet(d);
	end;
	close (arc_detalle);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
p:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,p);
		imprimirMaestro(p);
	end;
	close (arc_maestro);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
d:cDetalle;
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
deta:arDet;

begin
	Assign (arc_maestro,'maestro');
	writeln ('MAESTRO: ');
	{crearMaestro(arc_maestro);}
	mostrarMaestro (arc_maestro);
	for i:= 1 to n do begin
		writeln ('DETALLE ',i,' : ');
		Str (i,aString);
		Assign (deta[i],'detalle'+ aString);
		{crearDetalle (deta[i])}
		mostrarDetalle (deta[i]);
	end;
end.
