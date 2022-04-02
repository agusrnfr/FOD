program creadorArchivos;
uses crt;

type
cMaestro = record
	nombre:string;
	cant:integer;
	encu:integer;
end;


cDetalle = record
	nombre:string;
	cod:integer;
	cant:integer;
	encu:integer;
end;

maestro = file of cMaestro;

detalle = file of cDetalle;

procedure imprimirMae(c:cMaestro);
begin
	with c do begin
		writeln ('NOMBRE: ',nombre,' CANTIDAD: ',cant,' ENCUESTADOS: ',encu);
		writeln ('');
	end;
end;

procedure leerMae (var c:cMaestro);
begin
	with C do begin
		write ('INGRESE NOMBRE: '); readln (nombre);
		if (nombre <> '') then begin
			write ('INGRESE CANTIDAD: '); readln (cant);
			write ('INGRESE ENCUESTADOS: '); readln (encu);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet(c:cDetalle);
begin
	with c do begin
		writeln ('NOMBRE: ',nombre,' CODIGO: ',cod,' CANTIDAD: ',cant,' ENCUESTADOS: ',encu);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with C do begin
		write ('INGRESE NOMBRE: '); readln (nombre);
		if (nombre <> '') then begin
			write ('INGRESE CODIGO: '); readln (cod);
			write ('INGRESE CANTIDAD: '); readln (cant);
			write ('INGRESE ENCUESTADOS: '); readln (encu);
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
	while (p.nombre <> '') do begin
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
	while (d.nombre <> '') do begin
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



