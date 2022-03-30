{5. A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.
Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.
En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.
Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle,nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.
* 
Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única.
Tenga en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.

50 delegaciones 
 array de 50 con archivos de fallecimientos
 detalle fallecimiento -->	nro nacimiento
 * 					  		dni fallecido
 * 							nombre
 * 							matricula medico
 * 							fecha y hora deceso
 * 							lugar
 * 					

 array de 50 con archivos de nacimientos 
 detalle nacimiento --> nro partida
 * 						nnombre y apellido
 * 						direccion
 * 						matricula del mdico
 * 						nombre y apellido de la madre
 * 						dni de la madre
 * 						nombre y apellido del padre
 * 						dni del padre
 * 				
 MAESTRO
 * 						nro partida
 * 						nombre y apellido
 * 						direcc
 * 						matricula medico
 * 						nombre y apellido de la madre
 * 						dni de la madre
 * 						nombre y apellido del padre
 * 						dni del padre
 * 						fallecio --> true o false
 * 						registro fallecido --> 
 * 										matricula medico
* 										fecha y hora deceso
* 										lugar	puede ser <> a delegacion.	
 
}

program ejer5;
uses crt; 

CONST 
valorAlto = 9999;
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

cMaestro = record
	datos: alive;
	seMurio: boolean;
	enEfecto: fallecido;
end;

maestro = file of cMaestro; // lo tengo que crear

detalleVIVO = file of alive;
detalleMUERTO = file of dead;

arrayVIVO =array [1..n] of detalleVIVO;
arrayMUERTO = array [1..n] of detalleMUERTO;

arrayRV = array [1..n] of alive;
arrayRM = array [1..n] of dead;


procedure leerVIVO (var arc_detalle: detalleVIVO ; var dato:alive);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro:= valorAlto;
end;

procedure leerMUERTO (var arc_detalle: detalleMUERTO; var dato:dead);
begin
	if not eof (arc_detalle) then
		read (arc_detalle,dato)
	else
		dato.nro:= valorAlto;
end;

procedure imprimirMas (m:cMaestro);
begin
	with m do begin
		writeln ('|NRO: ',datos.nro,' |NOMBRE: ',datos.nombre,' |DIRECCION: ',datos.direccion,' |MATRICULA: ',datos.matricula);
		writeln ('NOMBRE MADRE: ',datos.nombreM,' |DNI MADRE: ',datos.dniM,' |NOMBRE PADRE: ', datos.nombreP,'| DNI PADRE: ', datos.dniP);
		writeln ('ESTA MUERTO?: ', seMurio,' |MATRICULA MEDICO: ', enEfecto.matricula);
		writeln ('FECHA: ', enEfecto.fecha,' |HORA DE FALLECIMIENTO: ',enEfecto.hora,' |LUGAR DE FALLECIMIENTO: ',enEfecto.lugar);
		writeln ('');
	end;
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

procedure minimoVIVO(var registro:arrayRV; var min:alive ; var deta: arrayVIVO);
var 
i,indiceMin: integer;
begin
	indiceMin:= 0;
	min.nro:= valorAlto;
	for i:= 1 to n do
		if (registro[i].nro <> valorAlto) then
			if (registro[i].nro < min.nro ) then begin
				min:= registro[i];
				indiceMin:= i;
			end;
	if (indiceMin <> 0) then begin
		leerVIVO(deta[indiceMin], registro[indiceMin]);	
	end;
end;

procedure minimoMUERTO (var registro:arrayRM; var min:dead ; var deta: arrayMUERTO);
var 
i,indiceMin: integer;
begin
	indiceMin:= 0;
	min.nro:= valorAlto;
	for i:= 1 to n do
		if (registro[i].nro <> valorAlto) then
			if (registro[i].nro < min.nro ) then begin
				min:= registro[i];
				indiceMin:= i;
			end;
	if (indiceMin <> 0) then begin
		leerMUERTO(deta[indiceMin], registro[indiceMin]);	
	end;
end;

procedure crearMaestro (var arc_maestro: maestro; var detaVIVO:arrayVIVO; var detaMUERTO: arrayMUERTO; var regVIVO: arrayRV; var regMUERTO: arrayRM);
var
minV: alive;
minM: dead;
m:cMaestro;
i:integer;
aString:string;
begin
	rewrite (arc_maestro);
	for i:= 1 to n do begin 
		Str (i,aString);
		Assign (detaVIVO[i],'detalleVIVO'+aString);
		reset (detaVIVO[i]);
		leerVIVO (detaVIVO[i],regVIVO[i]);
		Assign (detaMUERTO[i],'detalleMUERTO'+aString);
		reset (detaMUERTO[i]);
		leerMUERTO (detaMUERTO[i],regMUERTO[i]);
	end;
	minimoVIVO (regVIVO,minV,detaVIVO);
	minimoMUERTO (regMUERTO,minM,detaMUERTO);
	writeln (minV.nro,minM.nro);
	while (minV.nro <> valorAlto) do begin
		if (minV.nro = minM.nro) then begin
			m.seMurio:= true;
			m.enEfecto:= minM.datos;
			minimoMUERTO (regMUERTO,minM,detaMUERTO);
		end
		else begin
			m.seMurio:= false;
			m.enEfecto.matricula:='';
			m.enEfecto.fecha:='';
			m.enEfecto.hora:='';
			m.enEfecto.lugar:='';
		end;
		m.datos:= minV;
		write (arc_maestro,m);
		minimoVIVO (regVIVO,minV,detaVIVO);
	end;
	close (arc_maestro);
	for i:= 1 to n do 
		close (detaVIVO[i]);
		close (detaMUERTO[i]);
end;

var
arc_maestro: maestro;
detaVIVO: arrayVIVO;
detaMUERTO: arrayMUERTO;
regVIVO: arrayRV;
regMUERTO: arrayRM;

begin
	Assign (arc_maestro,'maestro');
	crearMaestro (arc_maestro,detaVIVO,detaMUERTO,regVIVO,regMUERTO);
	mostrarMaestro (arc_maestro);
end.


