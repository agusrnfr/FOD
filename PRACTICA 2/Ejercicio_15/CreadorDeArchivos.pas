program creadorArchivos;
uses crt;

CONST
n = 3;

type

cMaestro = record
	codP:integer;
	nomP:string;
	codL:integer;
	nomL:string;
	vSinL:integer;
	vSinG:integer;
	vDeC:integer;
	vSinA:integer;
	vSinS:integer;
end;

cDetalle = record
	codP:integer;
	codL:integer;
	vConL:integer;
	vConG:integer;
	vConst:integer;
	vConA:integer;
	vEntregaS:integer;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;


procedure leerMaestro (var c: cMaestro);
begin
	with c do begin 
		write ('INGRESE CODIGO PROVINCIA: '); readln (codP);
		if (codP <> -1) then begin
			write ('INGRESE NOMBRE PROVINCIA: '); readln (nomP);
			write ('INGRESE CODIGO LOCALIDAD: '); readln (codL);
			write ('INGRESE NOMBRE LOCALIDAD: '); readln (nomL);
			write ('INGRESE VIVIENDAS SIN LUZ: '); readln (vSinL);
			write ('INGRESE VIVIENDAS SIN GAS: '); readln (vSinG);
			write ('INGRESE VIVIENDAS DE CHAPA: '); readln (vDeC);
			write ('INGRESE VIVIENDAS SIN AGUA: '); readln (vSinA);
			write ('INGRESE VIVIENDAS SIN SANITARIOS: '); readln (vSinS);
		end;
		writeln ('');
	end;
end;

procedure imprimirMaestro (c:cMaestro);
begin
	with c do begin
		writeln ('CODIGO PROVINCIA: ',codP,' |NOMBRE PROVINCIA: ',nomP,' |CODIGO LOCALIDAD: ',codL,' |NOMBRE LOCALIDAD: ',nomL);
		writeln ('VIVIENDAS SIN LUZ: ',vSinL,' |VIVIENDAS SIN GAS: ',vSinG,' |VIVIENDAS DE CHAPA: ',vDeC,' |VIVIENDAS SIN AGUA: ',vSinA);
		writeln ('VIVIENDAS SIN SANITARIOS: ',vSinS);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with c do begin
		write ('INGRESE CODIGO PROVINCIA: '); readln (codP);
		if (codP <> -1) then begin
			write ('INGRESE CODIGO LOCALIDAD: '); readln (codL);
			write ('INGRESE VIVIENDAS CON LUZ: '); readln (vConL);
			write ('INGRESE VIVIENDAS CON GAS: '); readln (vConG);
			write ('INGRESE VIVIENDAS CONSTRUIDAS: '); readln (vConst);
			write ('INGRESE VIVIENDAS CON AGUA: '); readln (vConA);
			write ('INGRESE ENTREGA DE SANITARIOS: '); readln (vEntregaS);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (c:cDetalle);
begin
	with c do begin
		writeln ('CODIGO PROVINCIA: ',codP,' |CODIGO LOCALIDAD: ',codL);
		writeln ('VIVIENDAS CON LUZ: ',vConL,' |VIVIENDAS CON GAS: ',vConG,' |VIVIENDAS CONSTRUIDAS: ',vConst,' |VIVIENDAS CON AGUA: ',vConA);
		writeln ('ENTREGA DE SANITARIOS: ',vEntregas);
		writeln ('');
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
p:cMaestro;
begin
	rewrite (arc_maestro);
	leerMaestro (p);
	while (p.codP <> -1) do begin
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
	while (d.codP <> -1) do begin
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
{c:cMaestro;}
begin
	Assign (arc_maestro,'maestro');
	writeln ('MAESTRO: ');
	{reset (arc_maestro);
	while not eof (arc_maestro) do
		read(arc_maestro,c);
	leerMaestro(c);
	write (arc_maestro,c);
	close (arc_maestro);}
	{crearMaestro(arc_maestro);}
	mostrarMaestro (arc_maestro);
	for i:= 1 to n do begin
		writeln ('DETALLE ',i,' : ');
		Str (i,aString);
		Assign (deta[i],'detalle'+ aString);
		{crearDetalle (deta[i]);}
		{mostrarDetalle (deta[i]);}
	end;
end.

