program creadorArchivos;
uses crt;

CONST
n = 3;

type

cMaestro = record
	cod:integer;
	nom:string[25];
	des:string[100];
	mode:string[25];
	marca:string[25];
	stock:integer;
end;

cDetalle = record
	cod:integer;
	fecha:string[8];
	precio:real;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;

arDet = array [1..n] of detalle;

procedure leerMaestro (var c: cMaestro);
begin
	with c do begin 
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE NOMBRE: '); readln (nom);
			write ('INGRESE MODELO: '); readln (mode);
			write ('INGRESE MARCA: '); readln (marca);
			write ('INGRESE STOCK: '); readln (stock);
		end;
		writeln ('');
	end;
end;

procedure imprimirMaestro (c:cMaestro);
begin
	with c do begin
		writeln ('COD: ',cod,' NOMBRE: ',nom,' MODELO: ',mode,' MARCA: ',marca,' STOCK: ',stock);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with c do begin 
		write ('INGRESE COD: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE PRECIO: '); readln (precio);
			write ('INGRESE FECHA: '); readln (fecha);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (c:cDetalle);
begin
	with c do begin
		writeln ('COD: ',cod,' PRECIO: ',precio:2:2,'FECHA: ',fecha);
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
		{crearDetalle (deta[i]);}
		mostrarDetalle (deta[i]);
	end;
end.

