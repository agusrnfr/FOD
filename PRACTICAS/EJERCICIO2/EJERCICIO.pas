{Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla}

program Ejer1;

type 

	archivo = file of integer;

procedure mostrarPantalla (var arc_num:archivo; var cantM,cant:integer; var promedio:real);
var
	num: integer;
begin
	reset (arc_num);
	while not eof(arc_num) do begin
		cant:= cant + 1;
		read (arc_num,num);
		promedio:= promedio + num;
		if (num < 1500) then
			cantM:= cantM + 1;
		writeln (num);
	end;
	close (arc_num);
end;

var 
	arc_num: archivo;
	nombr: string[50];
	cantM: integer;
	promedio: real;
	cant: integer;
begin
	promedio:= 0;
	cant:= 0;
	cantM:= 0;
	write ('|INGRESE NOMBRE DEL ARCHIVO: ');
	readln (nombr);
	Assign(arc_num, nombr); // debo dar el nombre del archivo del ejer 1
	mostrarPantalla (arc_num,cantM,cant,promedio);
	writeln ('|LA CANTIDAD DE NUMEROS MENORES A 1500 ES: ',cantM);
	writeln ('|EL PROMEDIO DE NUMEROS INGRESADOS ES: ',promedio/cant:0:2);
end.	