{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}


program ejer1;

CONST
valorAlto = 9999;

type

empleado = record
	codigo: integer;
	nombre: string;
	montoC: real;
end;

compacto = record
	codigo:integer;
	montoC: real;
end;

detail = file of empleado;
master = file of compacto;

procedure leer2( var archivo: detail; var dato: empleado);
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

procedure crear (var arc_log:detail);
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

procedure imprimirCompacto(c:compacto);
begin
	writeln ('CODIGO: ',c.codigo);
	writeln ('MONTO COMISION: ',c.montoC:2:1);
end;

procedure reciboYCompacto (var maestro:master; var detalle:detail);
var
e:empleado;
c:compacto;
codActual:integer;
begin
	rewrite (maestro);
	reset (detalle);
	leer2 (detalle,e);
	while (e.codigo <> valorAlto) do begin
		codActual:= e.codigo; //el codigo del empleado que leo es el actual
		c.montoC:=0;   //reinicio los montos totales
		while (e.codigo = codActual) do begin //mientras sea el mismo empleado 
			c.montoC:= c.montoC + e.montoC;  //sumo montos
			leer2(detalle,e);  //vuelvo a leer empleado si no coincide sale del while
		end;
		c.codigo := codActual; //paso el codigo actual al compatado
		write (maestro,c); //escribo en detalle
	end;
	close (detalle);
	close (maestro);
end;

procedure mostrarDetalle (var detalle:detail);
var
e:empleado;
begin
	reset (detalle);
	while not eof (detalle) do begin
		read (detalle,e);
		imprimirEmpleado (e);
	end;
	close (detalle);
end;

procedure mostrarMaestro (var maestro:master);
var
c:compacto;
begin
	reset (maestro);
	while not eof (maestro) do begin
		read (maestro,c);
		imprimirCompacto (c);
	end;
	close (maestro);
end;


var
maestro:master;
detalle:detail;

begin
	Assign (maestro, 'arc_emp');
	Assign (detalle, 'arc_comp');
	crear (detalle);
	writeln ('');
	mostrarDetalle (detalle);
	writeln ('');
	reciboYCompacto (maestro,detalle);
	writeln ('');
	mostrarMaestro(maestro);
end.
