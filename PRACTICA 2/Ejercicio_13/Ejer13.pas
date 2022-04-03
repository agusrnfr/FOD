{13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema.
}

program ejer13;

CONST
valorAlto = 9999;

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

procedure leer (var arc_detalle:detalle; var dato:cDetalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro_usuario:= valorAlto;
end;

procedure actualizar (var arc_maestro:maestro; var arc_detalle:detalle);
var
dato:cDetalle;
m:cMaestro;
totalMensajes,nroActual:integer;
begin
	reset (arc_maestro);
	reset (arc_detalle);
	leer (arc_detalle,dato);
	while (dato.nro_usuario <> valorAlto) do begin
		nroActual:= dato.nro_usuario;
		totalMensajes:= 0;
		while (dato.nro_usuario = nroActual) do begin
			totalMensajes+= 1;
			leer (arc_detalle,dato);
		end;
		read (arc_maestro,m);
		while (m.nro_usuario <> nroActual) do begin
			read (arc_maestro,m);
		end;
		seek (arc_maestro,filePos (arc_maestro)-1);
		m.cantMail+= totalMensajes;
		write (arc_maestro,m);
	end;
	close (arc_detalle);
	close (arc_maestro);
end;

procedure infor (var arc_maestro:maestro; var arcTxt:Text);
var
m:cMaestro;
begin
	reset (arc_maestro);
	rewrite (arcTxt);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		with m do begin
			writeln (arcTxt,nro_usuario,'........',cantMail);
		end;
	end;
	writeln ('SE EXPORTO CON EXITO');
	close (arc_maestro);
	close (arcTxt);
end;

var
arc_maestro:maestro;
arc_detalle:detalle;
arcTxt:Text;
begin
	Assign (arc_maestro,'logmail.dat');
	Assign (arc_detalle,'detalle');
	Assign (arcTxt,'informe.txt');
	actualizar (arc_maestro,arc_detalle);
	infor (arc_maestro,arcTxt);
end.

