program ejer12;

CONST
valorAlto = 2023;

type
a = 2000..2023;
me = 1..12;
d = 1..31;

info = record
	anio:a;
	mes:me;
	dia:d;
	id:integer;
	tiempo: real;
end;

archivo = file of info;

procedure leer (var arc:archivo; var i:info);
begin
	if (not eof(arc)) then
		read(arc,i)
	else
		i.anio := valorAlto;
end;


procedure mostrar (var arc:archivo);
var
anio,mesActual,diaActual,usuarioActual:integer;
tiempoAnio,tiempoMes,tiempoDia,tiempoUs:real;
i:info;

begin
	reset(arc);
	write ('INGRESE ANIO: ');readln(anio);
	leer(arc,i);
	while(i.anio <> valorAlto) and (i.anio <> anio) do
		leer(arc,i);
	if (i.anio = anio) then begin
		tiempoAnio:= 0;
		writeln ('Anio:-- ',anio);
		while (i.anio = anio) do begin
			mesActual:= i.mes;
			tiempoMes:= 0;
			writeln ('Mes:-- ',mesActual);
			while (i.anio = anio) and (i.mes = mesActual) do begin
				diaActual:= i.dia;
				tiempoDia:= 0;
				writeln ('Dia:-- ',diaActual);
				while (i.anio = anio) and (i.mes = mesActual) and (i.dia = diaActual) do begin
					usuarioActual:= i.id;
					tiempoUs:= 0;
					while (i.anio = anio) and (i.mes = mesActual) and (i.dia = diaActual) and (i.id = usuarioActual) do begin
						tiempoUs+= i.tiempo;
						leer(arc,i);
					end;
					writeln ('idUsuario ',usuarioActual,' Tiempo Total de acceso en el dia ',diaActual,' mes ',mesActual);
					writeln (tiempoUs:2:2);
					writeln ('');
					tiempoDia+= tiempoUs;
				end;
				writeln ('Tiempo total acceso dia ',diaActual ,' mes ',mesActual);
				writeln (tiempoDia:2:2);
				writeln ('');
				tiempoMes+= tiempoDia;
			end;
			writeln ('Total tiempo de acceso mes ',mesActual);
			writeln (tiempoMes:2:2);
			writeln ('');
			tiempoAnio+= tiempoMes;
		end;
		writeln ('Total tiempo de accesos anio');
		writeln (tiempoAnio:2:2);
		writeln ('');
	end
	else
		writeln ('Anio no encontrado.');
	close(arc);
end;


var
arc:archivo;

begin
	Assign (arc,'maestro');
	mostrar(arc);
end.
