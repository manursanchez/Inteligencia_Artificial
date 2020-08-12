/*************************************************************
Base de conocimiento de un plan de formación.
Actividad práctica II, Fundamentos de Inteligencia Artificial
Autor: Manuel Rodríguez Sánchez
***************************************************************/


% ----------------------------BLOQUE 1 HECHOS Y PREDICADOS----------------------
% Constantes. Personal que organiza el plan de formacion El
% centro tiene un director que gestiona el personal
director.

%El centro tiene un tecnico que planifica acciones formativas
tecnicoFormacion.

%En un periodo de tiempo hay un plan de formacion
planDeFormacion.

:-dynamic (esDocente/1).

%Docentes o profesores del centro de formacion.
esDocente(juan). /*Juan es un docente*/
esDocente(manuel).
esDocente(sonia).
esDocente(ismael).

%Cursos del plan de formación

esCurso(excel). /*excel es un curso*/
esCurso(contabilidad).
esCurso(rrhh).
esCurso(comunicacion).

% docente(profesor, especialidad). Especialidad de los docentes o
% profesores
docente(manuel,informatica). /*manuel es especialista en informatica*/
docente(ismael,economicas).
docente(sonia,derecho).
docente(juan,psicologia).

%curso(curso,profesor). Cursos que imparte cada docente.
curso(excel,manuel). /*excel es impartido por manuel*/
curso(contabilidad,ismael).
curso(rrhh,juan).
curso(comunicacion,sonia).

% Número de grupo. Cada accion formativa se identifica por un
% codigo de grupo, y esto significa que un curso puede tener varias
% ediciones, identificando estas por su codigo de grupo.
% numeroGrupo(codigoGrupo, curso).
numeroGrupo(1,excel). /*el grupo 1 es una edicion del curso excel*/
numeroGrupo(2,excel).
numeroGrupo(3,excel).
numeroGrupo(4,contabilidad).
numeroGrupo(5,contabilidad).
numeroGrupo(6,rrhh). /*el grupo 6 es una edicion del curso rrhh*/
numeroGrupo(7,rrhh).
numeroGrupo(8,rrhh).
numeroGrupo(9,comunicacion).

% Presupuesto para cada uno de los grupos.
% presupuestoCurso(codigoGrupo,totalEuros).
presupuestoCurso(1,450). /*el grupo 1 tiene un presupuesto de 450 euros*/
presupuestoCurso(2,360).
presupuestoCurso(3,270).
presupuestoCurso(4,640).
presupuestoCurso(5,520).
presupuestoCurso(6,125).
presupuestoCurso(7,175).
presupuestoCurso(8,275).
presupuestoCurso(9,400).

% Número de alumnos por cada grupo previsto.
% numeroAlumnos(codigoGrupo,numerodeAlumnos)
numeroAlumnos(1,15). /*el grupo 1 tiene 15 alumnos*/
numeroAlumnos(2,12).
numeroAlumnos(3,9).
numeroAlumnos(4,16).
numeroAlumnos(5,13).
numeroAlumnos(6,5).
numeroAlumnos(7,7).
numeroAlumnos(8,11).
numeroAlumnos(9,20).


% ------------BLOQUE 2 - MENÚ DE OPCIONES PARA HACER LAS PREGUNTAS A LA BC------------------

%Esta regla limpia la pantalla y ejecuta el menú de opciones
iniciarprograma:-limpiaPantalla,programa.

%Borrar todo lo que hay en la pantalla
limpiaPantalla:-write('\033[2J').

%Menú de opciones
programa:-write('\nMenú de opciones:\n\n'),
		write('	1-Precio por alumno de un curso previsto.\n'),
		write('	2-Verificar un curso y su especialidad\n'),
		write('	3-Verificar curso que imparte un docente\n'),
		write('	4-Agregar un nuevo docente\n'),
		write('	5-Eliminar un docente\n'),
		write('	6-Listar los grupos de cursos que han sido ejecutados\n'),
		write('	7-Comprobar la especialidad de un curso\n'),
		write('	8-Comprobar que un curso se ha ejecutado\n'),
		write('	9-Comprobar que un curso se puede desarrollar\n'),
		write('	10-Salir\n\n'),
		write('Selecciona mediante su número, la opción que se desee ejecutar: '),
	read(Opcion),limpiaPantalla,opcion(Opcion).

%--------------------------------------------------------------------------------------------
% En esta opción, recogemos el nombre del curso, y vemos cuanto es su
% coste por alumno. Divide el total del presupuesto del curso entre el
% numero de alumnos de ese curso o edición. Cada curso (NO GRUPO) tiene
% un precio por alumno.
opcion(1):-!,write('\nNombre del curso: '),
	read(C),nl,
	numeroGrupo(G,C),presupuestoCurso(G,P),numeroAlumnos(G,N),Resultado is P/N,write('\nEl precio del curso por alumno es: '),write(Resultado),write(' Euros'),nl,nl,programa.

% opcion(2), vamos a preguntar si un curso pertenece a una especialidad.
opcion(2):-!,write('\nNombre del curso: '),
	read(Curso),
	write('\nEspecialidad del curso: '),
	read(Especialidad),(especialidadCurso(Curso, Especialidad)->write('Correcto\n\n');write('Los datos introducidos no son correctos\n\n')),programa.

% opcion(3), preguntamos si un curso lo imparte un docente siempre y
% cuando el director organice al docente y el tecnico de formacion
% planifique el curso.
opcion(3):-!,write('\nNombre del curso: '),
	read(Curso),
	write('\nIntroduce el profesor: '),
	read(Docente),organiza(director,Docente),planifica(tecnicoFormacion,Curso),(imparteCurso(Curso,Docente)->write('Correcto\n\n');write('Los datos introducidos no son correctos\n\n')),programa.

% Insertamos un docente en la lista de docentes. Se llama a la regla que
% realiza el assert
opcion(4):-!,write('\nNombre del docente(No introducir espacios): '),
	read(Docente),insertarDocente(Docente),programa.

% Eliminamos un docente de lista de docentes. Se llama a la regla que
% realiza el retract
opcion(5):-!,write('\nNombre del docente(No introducir espacios): '),
	read(Docente),eliminarDocente(Docente),programa.

%Se llama a la regla que lista los 9 grupos ejecutados
opcion(6):-!,nl,listaCursos(9),programa.

%Se verifica la especialidad a la que pertenece un curso
opcion(7):-!,write('\nNombre del curso: '),
	read(Curso),
	write('\nIntroduce la especialidad: '),
	read(Especialidad),(especialidadCurso(Curso,Especialidad)->write('Correcto\n\n');write('Los datos introducidos no son correctos\n\n')),programa.

%Se verifica si un grupo ha sido ejecutado.
opcion(8):-!,write('\nNumero de grupo: '),
	read(Grupo),(cursoEjecutado(Grupo,_)->write('El curso correspondiente al grupo, ha sido ejecutado\n\n');write('Los datos introducidos no son correctos\n\n')),programa.

%Se verifica si un curso se puede ejecutar o desarrollar
opcion(9):-!,write('\nIntroduce el curso: '),
	read(Curso),(desarrolloCurso(Curso)->write('El curso puede ser ejecutado\n\n');write('Los datos introducidos no son correctos\n\n')),programa.

%Si seleccionamos la opción 10, termina la ejecucion del programa
opcion(10):-!,write('\nPrograma finalizado\n').

% Si no se selecciona ninguna opción, se pedira nuevamente una entrada
opcion(_):-!,write('\nLa opción no es correcta o no existen datos, inténtelo de nuevo.\n\n'),programa.

% ---------------------------- BLOQUE 3 - REGLAS ------------------------------------

% Al menos uno de los predicados se define mediante dos o mas reglas.El
% curso ha sido planificado si el tecnico de formacion lo ha gestionado,
% el curso es impartido por un docente, y el curso es realmente un
% curso.
esPlanificado(C):-planifica(tecnicoFormacion,C),imparteCurso(C,_),esCurso(C).

%viene de la opcion 4
insertarDocente(D):-(assert(esDocente(D))->write('Docente insertado correctamente\n');write('Error en datos.Operación no realizada\n')).
%viene de la opcion 5
eliminarDocente(D):-(retract(esDocente(D))->write('Docente eliminado correctamente\n');write('No existe el docente\n')).

% Un curso se habrá ejecutado si ha tenido presupuesto y alumnos.Opcion
% 8
cursoEjecutado(G,_):-presupuestoCurso(G,_),numeroAlumnos(G,_).

%¿Pertenece el curso C a la especialidad E? Llamada desde la opcion 7
especialidadCurso(C,E):-curso(C,D),docente(D,E).

%¿Que curso es impartido por un docente? Llamada desde la opcion 3
imparteCurso(C,D):-curso(C,D).

% El tecnico de formacion planifica un curso, siempre que el curso C
% sea un curso
planifica(tecnicoFormacion,C):-esCurso(C).

% El director organiza el personal docente siempre que D sea un
% profesor
organiza(director,D):-esDocente(D).

% Un curso se va a desarrollar o empezar si ha sido planificado por el
% tecnico de formacion, el curso lo imparte un docente y el director
% organiza el docente que ha de impartirlo. Llamada por la opcion 9
desarrolloCurso(C):-esPlanificado(C),imparteCurso(C,D),organiza(director,D).

% Listamos los grupos de cursos ejecutados. Aquí se usa recursividad.
% Es llamada por la opcion 6
listaCursos(G):-(G\==0->numeroGrupo(G,C),write('Grupo: '),write(G),write(' Curso: '),write(C),nl,G1 is G-1,listaCursos(G1);write('Se han listado todos los grupos\n')).



