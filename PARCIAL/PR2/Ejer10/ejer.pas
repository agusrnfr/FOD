program ejer10;

CONST 
N = 15; 
valorAlto = 9999;

type
cat = 1..N;

emp = record
	dep: integer;
	divi :integer;
	nro : integer;
	categoria: cat;
	horas: integer;
end;

crec = record
	categoria : cat;
	valor :real;
end;

archivo = file of emp;

arreglo = array [cat] of real;

procedure leer (var arc:archivo; var e:emp);
begin
	if (not eof (arc)) then
		read (arc,e)
	else
		e.dep := valorAlto;
end;

procedure exportar (var arc:text ; var a:arreglo);
var
c:crec;
begin
	reset (arc);
	while not (eof(arc)) do begin
		with c do begin
			readln (arc,categoria,valor);
			a[categoria]:= valor;
		end;
	end;
	close (arc);
end;


procedure mostrar (var arc:archivo; a:arreglo);
var
depActual,divActual,empActual,horasDep,horasDiv,horasEmp:integer;
impDep,impDiv,impEmp:real;
e:emp;

begin
	reset (arc);
	leer(arc,e);
	while (e.dep <> valorAlto) do begin
		depActual:= e.dep;
		horasDep:= 0;
		impDep:= 0;
		writeln ('DEPARTAMENTO: ',depActual);
		while (e.dep = depActual) do begin
			divActual:= e.divi;
			horasDiv:= 0;
			impDiv:= 0;
			writeln ('DIVISION: ',divActual);
			writeln ('NUMERO EMPLEADO    TOTAL HORAS     IMPORTE');
			while (e.dep = depActual) and (e.divi = divActual) do begin
				impEmp:= 0;
				empActual:= e.nro;
				horasEmp:= 0;
				while (e.dep = depActual) and (e.divi = divActual) and (e.nro = empActual) do begin
					horasEmp+= e.horas;
					impEmp+= e.horas * a[e.categoria];
					leer(arc,e);
				end;
				writeln (empActual,'                 ', horasEmp,'               ',impEmp:0:2);
				horasDiv+= horasEmp;
				impDiv+= impEmp;
			end;
			writeln ('TOTAL HORAS DIV: ', horasDiv);
			writeln ('MONTO TOTAL POR DIV: ',impDiv:0:2);
			horasDep+= horasDiv;
			impDep+= impDiv;
			writeln ('');
			writeln ('');
		end;
		writeln ('TOTAL HORAS DEPARTAMENTO: ',horasDep);
		writeln ('TOTAL MONTO: ',impDep:0:2);
	end;
	close (arc);
end;

var
arcTxt: text;
arc: archivo;
a:arreglo;

begin
	Assign (arcTxt,'monto.txt');
	Assign (arc,'maestro');
	exportar(arcTxt,a);
	mostrar(arc,a);
end.
