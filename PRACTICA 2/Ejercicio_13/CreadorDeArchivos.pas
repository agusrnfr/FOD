program creadorArchivos;
uses crt;

type

cMaestro = record
	nro_usuario:integer;
	nombreUsuario:string;
	nombre:string;
	apellido:string;
	cantMail:integer;
end;

cDetalle = record
	nro_usuario:integer;
	cuentaDestino:string;
	cuerpo:string;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;


procedure leerMaestro (var c:cMaestro);
begin
	with c do begin 
		write ('INGRESE NRO USUARIO: '); readln (nro_usuario);
		if (nro_usuario <> -1) then begin
			write ('INGRESE NOMBRE DE USUARIO: '); readln (nombreUsuario);
			write ('INGRESE NOMBRE: '); readln (nombre);
			write ('INGRESE APELLIDO: '); readln (apellido);
			write ('INGRESE CANTIDAD MAILS ENVIADOS: '); readln (cantMail);
		end;
		writeln ('');
	end;
end;

procedure imprimirMaestro (c:cMaestro);
begin
	with c do begin
		writeln ('NRO USUARIO: ',nro_usuario,' NOMBRE DE USUARIO: ',nombreUsuario,' NOMBRE: ',nombre,' APELLIDO: ',apellido);
		writeln ('CANTIDAD MAILS ENVIADOS: ',cantMail);
		writeln ('');
	end;
end;

procedure leerDet (var c:cDetalle);
begin
	with c do begin
		write ('INGRESE NRO USUARIO: '); readln (nro_usuario);
		if (nro_usuario <> -1) then begin
			write ('INGRESE CUENTA DESTINO: '); readln (cuentaDestino);;
			write ('INGRESE CUERPO DEL MENSAJE: ');readln (cuerpo);
		end;
		writeln ('');
	end;
end;

procedure imprimirDet (c:cDetalle);
begin
	with c do begin
		writeln ('CODIGO: ',nro_usuario,' CUENTA DESTINO: ',cuentaDestino,' CUERPO MENSAJE: ',cuerpo);
		writeln ('');
	end;
end;

procedure crearMaestro (var arc_maestro:maestro);
var
c:cMaestro;
begin
	rewrite (arc_maestro);
	leerMaestro (c);
	while (c.nro_usuario <> -1) do begin
		write (arc_maestro,c);
		leerMaestro(c);
	end;
	close (arc_maestro);
end;

procedure crearDetalle (var arc_detalle:detalle);
var
c:cDetalle;
begin
	rewrite (arc_detalle);
	leerDet (c);
	while (c.nro_usuario <> -1) do begin
		write (arc_detalle,c);
		leerDet(c);
	end;
	close (arc_detalle);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
c:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,c);
		imprimirMaestro(c);
	end;
	close (arc_maestro);
end;

procedure mostrarDetalle (var arc_detalle:detalle);
var
c:cDetalle;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,c);
		imprimirDet(c);
	end;
	close (arc_detalle);
end;

var
arc_maestro: maestro;
arc_det:detalle;

begin
	Assign (arc_maestro,'logmail.dat');
	Assign (arc_det,'detalle');
	{crearMaestro (arc_maestro);}
	mostrarMaestro (arc_maestro);
	{crearDetalle (arc_det);}
	mostrarDetalle (arc_det);
end.


