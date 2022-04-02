{12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
* 
* Se deberá tener en cuenta las siguientes aclaraciones:
- El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
- El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
- Debe definir las estructuras de datos necesarias.
- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.
* }
program ejer12;

CONST
valorAlto = 2023;

type
a = 2000..2023;
me = 1..12;
d = 1..31;

cMaestro = record
	anio:a;
	mes:me;
	dia:d;
	idUs:integer;
	tiempoAc: real;
end;

maestro = file of cMaestro;

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.anio := valorAlto;
end;

procedure mostrar (var arc_maestro:maestro; anio:a);
var
m:cMaestro;
total,totalMes,totalDia,totalId:real;
mesActual:me;
diaActual:d;
idActual:integer;
ok:boolean;
begin
	ok:= false;
	reset (arc_maestro);
	leer (arc_maestro,m);
	while (m.anio <> valorAlto) and (m.anio <> anio) do begin
		leer (arc_maestro,m);
	end;
	total:= 0;
	while (m.anio = anio) do begin
		ok:= true;
		mesActual:= m.mes;
		writeln ('Mes:-- ',m.mes);
		totalMes:= 0;
		while (m.anio = anio) and (m.mes = mesActual) do begin
			diaActual:= m.dia;
			writeln ('Dia:-- ',m.dia);
			totalDia:= 0;
			while (m.anio = anio) and (m.mes = mesActual) and (m.dia = diaActual) do begin
				idActual:= m.idUs;
				totalId:= 0;
				while (m.anio = anio) and (m.mes = mesActual) and (m.dia = diaActual) and (m.idUs = idActual) do begin
					totalId+= m.tiempoAc;
					leer (arc_maestro,m);
				end;
				writeln ('idUsuario ',idActual,' Tiempo Total de acceso en el dia ',diaActual,' mes ',mesActual);
				writeln ('	',totalId:2:2);
				writeln ('');
				totalDia+= totalId;
			end;
			writeln ('Tiempo total acceso dia ',diaActual ,' mes ',mesActual);
			writeln ('	',totalDia:2:2);	
			writeln ('');
			totalMes+= totalDia;
		end; 
		writeln ('Total tiempo de acceso mes ',mesActual);
		writeln ('	',totalMes:2:2);
		writeln ('');
		total+= totalMes;
	end;
	if (ok)	then begin
		writeln ('Total tiempo de accesos anio');
		writeln ('	',total:2:2);
	end
	else
		writeln ('Anio no encontrado.');
end;


var
arc_maestro:maestro;
anio:a;

begin
	Assign (arc_maestro,'maestro');
	write ('INGRESE ANIO: ');
	readln(anio);
	writeln ('');
	mostrar (arc_maestro,anio);
end.
