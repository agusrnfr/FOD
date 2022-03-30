program Creador;
uses crt;

CONST 
n = 3;

type

fallecido = record
	matricula: string;
	fecha: string;
	hora:string;
	lugar:string;
end;

dead = record
	nro: integer;
	dni: string[8];
	nombre:string;
	datos: fallecido;
end;

alive = record
	nro: integer;
	nombre: string;
	direccion:	string;
	matricula:	string;
	nombreM:	string;
	dniM:	string;
	nombreP:	string;
	dniP:	string;
end;

detalleVIVO = file of alive;
detalleMUERTO = file of dead;

arrayVIVO =array [1..n] of detalleVIVO;
arrayMUERTO = array [1..n] of detalleMUERTO;

procedure leerMUERTO (var m:dead);
begin
	with m do begin
		write ('INGRESE NRO: '); readln (nro);
		if (nro <> -1) then begin
			write ('INGRESE DNI: '); readln(dni);
			write ('INGRESE NOMBRE: '); readln (nombre);
			write ('INGRESE MATRICULA MEDICO: '); readln (datos.matricula);
			write ('INGRESE FECHA: '); readln (datos.fecha);
			write ('INGRESE HORA: '); readln (datos.hora);
			write ('INGRESE LUGAR: '); readln (datos.lugar);
		end;
		writeln ('');
	end;
end;

procedure leerVIVO (var m:alive);
begin
	with m do begin
		write ('INGRESE NRO: '); readln (nro);
		if (nro <> -1) then begin
			write ('INGRESE NOMBRE: '); readln (nombre);
			write ('INGRESE DIRECCION: '); readln (direccion);
			write ('INGRESE MATRICULA MEDICO: '); readln (matricula);
			write ('INGRESE NOMBRE MADRE: '); readln (nombreM);
			write ('INGRESE DNI MADRE: '); readln (dniM);
			write ('INGRESE NOMBRE PADRE: '); readln (nombreP);
			write ('INGRESE DNI PADRE: '); readln (dniP);
		end;
		writeln ('');
	end;
end;

procedure crearDetalleVIVO (var arc_detalle:detalleVIVO);
var
d:alive;
begin
	rewrite (arc_detalle);
	leerVIVO(d);
	while (d.nro <> -1) do begin
		write (arc_detalle,d);
		leerVIVO(d);
	end;
	close (arc_detalle);
end;

procedure crearDetalleMUERTO (var arc_detalle:detalleMUERTO);
var
d:dead;
begin
	rewrite (arc_detalle);
	leerMUERTO(d);
	while (d.nro <> -1) do begin
		write (arc_detalle,d);
		leerMUERTO (d);
	end;
	close (arc_detalle);
end;

procedure imprimirDetVIVO (d:alive);
begin
	with d do begin
		writeln ('NRO: ',nro,' |NOMBRE: ',nombre,' |DIRECCION: ',direccion,' |MATRICULA MEDICO: ',matricula);
		writeln ('NOMBRE MADRE: ',nombreM,' |DNI MADRE: ',dniM,' |NOMBRE PADRE: ',nombreP,' |DNI PADRE: ',dniP);	
		writeln ('');
	end;
end;

procedure imprimirDetMUERTO (d:dead);
begin
	with d do begin
		writeln ('NRO: ',nro,' |DNI: ',dni,' |NOMBRE: ',nombre,' |MATRICULA MEDICO: ',datos.matricula);
		writeln ('FECHA: ',datos.fecha,' |HORA: ',datos.hora,' |LUGAR: ',datos.lugar);
		writeln ('');
	end;
end;

procedure mostrarDetalleVIVO (var arc_detalle:detalleVIVO);
var
d:alive;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimirDetVIVO(d);
	end;
	close (arc_detalle);
end;

procedure mostrarDetalleMUERTO (var arc_detalle:detalleMUERTO);
var
d:dead;
begin
	reset (arc_detalle);
	while not eof (arc_detalle) do begin
		read (arc_detalle,d);
		imprimirDetMUERTO(d);
	end;
	close (arc_detalle);
end;

var
aString: string;
i:integer;
detaVIVO: arrayVIVO;
detaMUERTO: arrayMUERTO;
begin
	writeln ('ACTA NACIMIENTO: ');
	writeln ('');
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (detaVIVO[i],'detalleVIVO'+ aString);
		{crearDetalleVIVO (detaVIVO[i]);}
		mostrarDetalleVIVO(detaVIVO[i]);
	end;
	writeln ('ACTA FALLECIMIENTO: ');
	writeln ('');
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (detaMUERTO[i],'detalleMUERTO'+aString);
		{crearDetalleMUERTO (detaMUERTO[i]);}
		mostrarDetalleMUERTO(detaMUERTO[i]);
	end;
end.
