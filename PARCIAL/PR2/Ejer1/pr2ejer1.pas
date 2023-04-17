program ejer1;

CONST
valorAlto = 9999;

type

empleado = record
	codigo: integer;
	nombre: string;
	montoC: real;
end;

archivo = file of empleado;

procedure leer2( var archivo: archivo; var dato: empleado);
begin
 if (not(EOF(archivo))) then
 read (archivo, dato)
 else
 dato.codigo := valorAlto;
end;

procedure leer (var e: empleado);
begin
	with e do begin 
		write ('INGRESE CODIGO EMPLEADO: '); readln (codigo);
		if (codigo <> -1) then begin
			write ('INGRESE NOMBRE DEL EMPLEADO: '); readln (nombre);
			write ('INGRESE MONTO DE LA COMISION: '); readln (montoC);
		end;
		writeln ('');
	end;
end;

procedure crear (var arc_log:archivo);
var
	e:empleado;
begin
	rewrite (arc_log);
	leer (e);
	while (e.codigo <> -1) do begin
		write (arc_log,e);
		leer (e);
	end;
	close (arc_log);
end;

procedure imprimirEmpleado (e:empleado);
begin
	writeln ('CODIGO: ',e.codigo);
	writeln ('NOMBRE: ',e.nombre);
	writeln ('MONTO COMISION: ',e.montoC:2:1);
end;

procedure reciboYCompacto (var arc:archivo; var arc_nuevo:archivo);
var
e:empleado;
aux:empleado;
suma:real;
begin
	rewrite (arc_nuevo);
	reset (arc);
	leer2 (arc,e);
	while (e.codigo <> valorAlto) do begin
		aux:= e;
		suma:=0;
		while (e.codigo = aux.codigo) do begin //mientras sea el mismo empleado 
			suma+=e.montoC;  //sumo montos
			leer2(arc,e);  //vuelvo a leer empleado si no coincide sale del while
		end;
		aux.montoC:= suma; //paso el codigo actual al compatado
		write (arc_nuevo,aux); //escribo en detalle
	end;
	close (arc);
	close (arc_nuevo);
end;

procedure mostrar (var arc:archivo);
var
e:empleado;
begin
	reset (arc);
	while not eof (arc) do begin
		read (arc,e);
		imprimirEmpleado (e);
	end;
	close (arc);
end;

var
arc,arc_nuevo:archivo;

begin
	Assign (arc, 'arc_emp');
	Assign (arc_nuevo, 'arc_comp');
	//crear (arc);
	writeln ('');
	mostrar(arc);
	writeln ('');
	reciboYCompacto (arc,arc_nuevo);
	writeln ('');
	mostrar (arc_nuevo);
end.
