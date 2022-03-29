{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}



program ejer4;
uses crt;

CONST
n = 4;
valorAlto = 9999;

type

cDetalle = record
	cod_usuario:integer;
	fecha:string;
	tiempo_sesion:real;
end;

cMaestro = record
	cod_usuario: integer;
	fecha:string;
	tiempo_total_de_sesiones_abiertas: real;
end;

maestro = file of cMaestro;
detalle = file of cDetalle;
ar_detalle = array [1..n] of detalle;
reg_detalle = array [1..n] of cDetalle;

procedure imprimirMas (m:cMaestro);
begin
	with m do begin
		writeln ('CODIGO: ',cod_usuario);
		writeln ('FECHA: ',fecha);
		writeln ('TIEMPO TOTAL DE SESIONES ABIERTAS ',tiempo_total_de_sesiones_abiertas:1:1);
		writeln ('');
	end;
end;

procedure leer (var arc_detalle: detalle; var dato:cDetalle);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.cod_usuario:= valorAlto;
end;

procedure minimo (var registro:reg_detalle; var min:cDetalle ; var deta: ar_detalle);
var 
i,indiceMin: integer;
begin
	indiceMin:= 0;
	min.cod_usuario:= valorAlto;
	for i:= 1 to n do
		if (registro[i].cod_usuario <> valorAlto) then
			if (registro[i].cod_usuario < min.cod_usuario ) then begin
				min:= registro[i];
				indiceMin:= i;
			end;
	if (indiceMin <> 0) then begin
		leer(deta[indiceMin], registro[indiceMin]);	
	end;
end;

procedure crearMaestro (var arc_maestro:maestro; var deta:ar_detalle;var registro:reg_detalle);
var
min:cDetalle;
i:integer;
aString: string;
m: cMaestro;

begin
	rewrite (arc_maestro);
	for i:= 1 to n do begin
		Str (i,aString);
		Assign (deta[i],'detalle'+aString);
		reset (deta[i]);
		leer (deta[i],registro[i]);
	end;
	minimo (registro,min,deta);
	while (min.cod_usuario <> valorAlto) do begin
		m.cod_usuario:= min.cod_usuario;
		m.tiempo_total_de_sesiones_abiertas:= 0;
		while (min.cod_usuario = m.cod_usuario) do begin
			m.tiempo_total_de_sesiones_abiertas:= m.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
			m.fecha:= min.fecha; //LA MAS RECIENTE.
			minimo (registro,min,deta);
		end;
		write (arc_maestro,m);
	end;
	close (arc_maestro);
	for i:= 1 to n do 
		close (deta[i]);
end;

procedure mostrarMaestro (var arc_maestro:maestro);
var
m:cMaestro;
begin
	reset (arc_maestro);
	while not eof (arc_maestro) do begin
		read (arc_maestro,m);
		imprimirMas(m);
	end;
	close (arc_maestro);
end;

var
arc_maestro:maestro;
deta: ar_detalle;
registro:reg_detalle;

begin
	Assign (arc_maestro,'maestro');
	crearMaestro (arc_maestro,deta,registro);
	mostrarMaestro (arc_maestro);
end.

