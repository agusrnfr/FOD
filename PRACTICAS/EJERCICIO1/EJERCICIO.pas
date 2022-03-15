{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}


program Ejer1;

type 

	archivo = file of integer;

var 
	arc_num: archivo;
	num: integer;
	nombr: string[50];

begin
	write ('|INGRESE NOMBRE DEL ARCHIVO: ');
	readln (nombr);
	Assign(arc_num, nombr);
	rewrite (arc_num);
	write ('|INGRESE NUMERO ENTERO: '); 
	readln (num);
	while (num <> 30000) do begin
		write (arc_num,num);
		write ('|INGRESE NUMERO ENTERO: '); 
		readln (num);	
	end;
	close (arc_num);
end.	
	