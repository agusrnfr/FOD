{Se tiene información en un archivo de las horas extras realizadas por los empleados de
una empresa en un mes. Para cada empleado se tiene la siguiente información:
departamento, división, número de empleado, categoría y cantidad de horas extras
realizadas por el empleado. Se sabe que el archivo se encuentra ordenado por
departamento, luego por división, y por último, por número de empleados. Presentar en
pantalla un listado con el siguiente formato
* Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.}

program ejer10;

CONST
valorAlto = 9999;
n = 15;

type
categ = 1..n;
empleado = record
	departamento:integer;
	division:integer;
	nro:integer;
	categoria:categ;
	cantHoras:integer;
end;

maestro = file of empleado;

cat = record
	nro:categ;
	monto:real;
end;

vec = array [categ] of real;

procedure cargarVec (var carga:Text; var v:vec);
var
i:integer;
c:cat;
begin
	reset (carga);
	for i:= 1 to n do begin
		readln (carga,c.nro,c.monto);
		v[c.nro]:= c.monto;
	end;
	close (carga);
end;

procedure leer (var arc_maestro:maestro; var dato:empleado);
begin
	if not eof (arc_maestro) then
		read (arc_maestro,dato)
	else
		dato.departamento:= valorAlto;
end;

procedure pantalla (var arc_maestro:maestro; var v:vec);
var
m:empleado;
totalDepartamento,totalDivision,totalNro:real;
totalHsDep,totalHsDiv,totalHsEmp,depActual,divActual,nroActual:integer;
begin
	reset (arc_maestro);
	leer (arc_maestro,m);
	while (m.departamento <> valorAlto) do begin
		depActual:= m.departamento;
		totalDepartamento:=0;
		totalHsDep:= 0;
		writeln ('|DEPARTAMENTO');
		writeln (' ',m.departamento);
		while (m.departamento = depActual) do begin
			writeln ('|DIVISION');
			writeln (' ',m.division);
			divActual:= m.division;
			totalDivision:= 0;
			totalHsDiv:= 0;
			writeln ('|NUMERO DE EMPLEADO	|TOTAL DE HS.	|IMPORTE A COBRAR');
			while (m.departamento = depActual) and (m.division = divActual) do begin
				nroActual:= m.nro;
				totalNro:= 0;
				totalHsEmp:= 0;
				while (m.departamento = depActual) and (m.division = divActual) and (m.nro = nroActual) do begin
					totalNro+=v[m.categoria] * m.cantHoras;
					totalHsEmp+= m.cantHoras;
					leer (arc_maestro,m);
				end;
				writeln (' ',nroActual,'			 ',totalHsEmp,'	    	',totalNro:2:2);
				totalDivision+= totalNro;
				totalHsDiv+= totalHsEmp;
			end;
			writeln ('TOTAL DE HORAS DIVISION: ',totalHsDiv);
			writeln ('MONTO TOTAL POR DIVISION: ',totalDivision:2:2);
			totalHsDep+= totalHsDiv;
			totalDepartamento+= totalDivision;
			writeln ('');
			writeln ('');
		end;
		writeln ('TOTAL DE HORAS DEPARTAMENTO: ',totalHsDep);
		writeln ('MONTO TOTAL DEPARTAMENTO: ',totalDepartamento:2:2);
	end;
	close (arc_maestro);
end;

var
arc_maestro:maestro;
v:vec;
arcTxt:Text;

begin
	Assign (arc_maestro,'maestro');
	Assign (arcTxt,'monto.txt');
	cargarVec(arcTxt,v);
	pantalla (arc_maestro,v);
end.
