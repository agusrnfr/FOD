program creadorDeArchivos;

type
cMaestro = record
destino:string;
fecha:string;
hora:string;
cantAs:integer;
end;

cDetalle = record
destino:string;
fecha:string;
hora:string;
cantAs:integer;
end;

maestro = file of cMaestro;

detalle = file of cDetalle;

procedure imprimirMae(c:cMaestro);
begin
	with c do begin
		writeln ('DESTINO: ',destino,' FECHA: ',fecha,' HORA: ',hora,' CANTIDAD ASIENTOS: ',cantAs);
		writeln ('');
	end;
end;

procedure leerMae (var c:cMaestro);
begin
	with C do begin
		write ('INGRESE DESTINO: '); readln (destino);
		if (destino <> '') then begin
			write ('INGRESE FECHA: '); readln (fecha);
			write ('INGRESE HORA: '); readln (hora);
			write ('INGRESE CANTIDAD ASIENTOS DISPONIBLES: '); readln (cantAs);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet(c:cDetalle);
begin
	with c do begin
		writeln ('DESTINO: ',destino,' FECHA: ',fecha,' HORA: ',hora,' CANTIDAD ASIENTOS VENDIDOS: ',cantAs);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with C do begin
		write ('INGRESE DESTINO: '); readln (destino);
		if (destino <> '') then begin
			write ('INGRESE FECHA: '); readln (fecha);
			write ('INGRESE HORA: '); readln (hora);
			write ('INGRESE CANTIDAD ASIENTOS VENDIDOS: '); readln (cantAs);
		end;
		writeln ('');
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
p:cMaestro;
begin
	rewrite (arc_maestro);
	leerMae (p);
	while (p.destino <> '') do begin
		write (arc_maestro,p);
		leerMae(p);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
d:cDetalle;
begin
	rewrite (arc_detalle);
	leerDet (d);
	while (d.destino <> '') do begin
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
		imprimirMae(p);
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
det1,det2:detalle;

begin
	Assign (arc_maestro,'maestro');
	Assign (det1,'detalle1');
	Assign (det2,'detalle2');
	{crearMaestro(arc_maestro);}
	mostrarMaestro (arc_maestro);
	{crearDetalle (det1); crearDetalle(det2);}
	writeln ('DETALLE 1');mostrarDetalle (det1); 
	writeln ('DETALLE 2');mostrarDetalle (det2);
end.
