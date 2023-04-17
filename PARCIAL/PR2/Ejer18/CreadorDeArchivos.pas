program crear;

CONST
n = 15;

type

cMaestro = record
	cod_localidad:integer;
	nom_localidad:string[25];
	cod_municipio:integer;
	nom_municipio:string[25];
	cod_hospital:integer;
	nom_hospital:string[25];
	fecha:string[8];
	cantCasos:integer;
end;

maestro = file of cMaestro;

procedure imprimirCl(c:cMaestro);
begin
	with c do begin
		writeln ('CODIGO LOCALIDAD: ',cod_localidad,' NOMBRE LOCALIDAD: ',nom_localidad,' CODIGO MUNICIPIO: ',cod_municipio,' NOMBRE MUNICIPIO: ',nom_municipio);
		writeln ('CODIGO HOSPITAL: ',cod_hospital,' NOMBRE HOSPITAL: ',nom_hospital,' FECHA: ',fecha,' CANTIDAD CASOS: ',cantCasos);
	end;
end;

procedure leerCl (var c:cMaestro);
begin
	with C do begin
		write ('INGRESE CODIGO LOCALIDAD: '); readln (cod_localidad);
		if (cod_localidad <> -1) then begin
			write ('INGRESE NOMBRE LOCALIDAD: '); readln (nom_localidad);
			write ('INGRESE CODIGO MUNICIPIO: '); readln (cod_municipio);
			write ('INGRESE NOMBRE MUNICIPIO: '); readln (nom_municipio);
			write ('INGRESE CODIGO HOSPITAL: ');readln (cod_hospital);
			write ('INGRESE NOMBRE HOSPITAL: ');readln (nom_hospital);
			write ('INGRESE FECHA: '); readln (fecha);
			write ('INGRESE CANTIDAD DE CASOS: '); readln (cantCasos);
		end;
		writeln ('');
	end;
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
c:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,c);
		imprimirCl(c);
		writeln ('');
	end;
	close (arc_maestro);
end;

procedure crear (var arc_maestro:maestro);
var
c:cMaestro;
begin
	rewrite (arc_maestro);
	leerCl (c);
	while (c.cod_localidad <> -1) do begin
		write (arc_maestro,c);
		leerCl(c);
	end;
	close (arc_maestro);
end;

var
arc_maestro:maestro;
begin
	Assign (arc_maestro,'maestro');
	{crear (arc_maestro);}
	mostrarMaestro (arc_maestro);
end.


