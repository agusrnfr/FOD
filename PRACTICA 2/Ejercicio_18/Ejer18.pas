{18 . Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene:
cod_localidad, nombre_localidad, cod_municipio, nombre_minucipio, cod_hospital,
nombre_hospital, fecha y cantidad de casos positivos detectados.
El archivo está ordenado por localidad, luego por municipio y luego por hospital.
a. Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga
un listado con el siguiente formato:
b. Exportar a un archivo de texto la siguiente información nombre_localidad,
nombre_municipio y cantidad de casos de municipio, para aquellos municipios cuya
cantidad de casos supere los 1500. El formato del archivo de texto deberá ser el
adecuado para recuperar la información con la menor cantidad de lecturas posibles.
NOTA: El archivo debe recorrerse solo una vez.}

program ejer18;

CONST
valorAlto = 9999;

type

cMaestro = record
	cod_localidad:integer;
	nom_localidad:string[25];
	cod_municipio:integer;
	nom_municipio:string[25];
	cod_hospital:integer;
	nom_hospital:string[25];
	fecha:string[8];
	cantCasos:integer;
end;

maestro = file of cMaestro;

procedure leer (var arc_maestro:maestro; var dato:cMaestro);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.cod_localidad:= valorAlto;
end;

procedure pantalla (var arc_maestro:maestro; var arcTxt:Text); 
var
m:cMaestro;
locActual,munActual,hosActual,total,locCasos,munCasos,hosCasos:integer;
nomHospital,nomLoc,nomMunicipio:string;
begin
	reset (arc_maestro);
	rewrite (arcTxt);
	leer (arc_maestro,m);
	total:= 0;
	while (m.cod_localidad <> valorAlto) do begin
		writeln ('NOMBRE LOCALIDAD: ',m.nom_localidad);
		locActual:= m.cod_localidad;
		locCasos:= 0;
		while (locActual = m.cod_localidad) do begin
			writeln ('  NOMBRE MUNICIPIO: ',m.nom_municipio);
			munActual:= m.cod_municipio;
			munCasos:= 0;
			nomLoc:= m.nom_localidad;
			while (locActual = m.cod_localidad) and (munActual = m.cod_municipio) do begin
				hosActual:= m.cod_hospital;
				hosCasos:= 0;
				nomMunicipio:= m.nom_municipio;
				while (locActual = m.cod_localidad) and (munActual = m.cod_municipio) and (hosActual = m.cod_hospital)do begin 
					hosCasos+= m.cantCasos;
					nomHospital:= m.nom_hospital;
					leer (arc_maestro,m);
				end;
				writeln ('   NOMBRE HOSPITAL: ',nomHospital,'.....................................CANTIDAD CASOS:  ',hosCasos);
				munCasos+=hosCasos;
			end;
			if (munCasos > 1500) then begin
				writeln (arcTxt,munCasos,' ',nomMunicipio);
				writeln (arcTxt,nomLoc);
			end;
			writeln ('  CANTIDAD CASOS MUNICIPIO ',munActual);
			writeln ('  ',munCasos);
			locCasos+= munCasos;
		end;
		writeln ('CANTIDAD CASOS LOCALIDAD ',locActual);
		writeln (locCasos);
		writeln ('');
		total+=locCasos;
	end;
	writeln ('CANTIDAD DE CASOS TOTALES EN LA PROVINCIA ');
	writeln (total);
	close (arc_maestro);
	close (arcTxt);
end;

var
arc_maestro:maestro;
arcTxt:Text;

begin
	Assign (arc_maestro,'maestro');
	Assign (arcTxt,'exportar.txt');
	pantalla (arc_maestro,arcTxt);
end.

