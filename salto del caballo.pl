% Comprueba si en un nodo del espacio de búsqueda contiene un camino completo
fullPath(Node) :- es_completo(Node).

% Comprueba que en el tablero (Board) de tamaño N, se puede ir a la
% casilla s(F,R), porque está en el tablero (inBoard) y está libre
% (freeSquare). Además coloca (pone a false esa posición en Board con
% visitSquare) el caballo en la posición s(F,R), construyendo el nuevo
% tablero(BoardNuevo)
validSquare(N,s(F,R), Board, NewBoard) :- inBoard(N,s(F,R)),freeSquare(s(F,R),Board),visitSquare(s(F,R),Board,NewBoard).

% Dada una casilla(s(F,R)), cambiar su valor a falso en un tablero
% dado(Board)
visitSquare(s(F,R), Board, BoardSol):- visitF(s(F,R), Board, BoardSol).

% Comprobar si la casilla s(F,R) está dentro de un tablero de tamaño N
inBoard(N,s(F,R)):-  N>0, F>0, R>0, N>=F, N>=R.

% Comprueba que la casilla no ha sido visitada
freeSquare(s(F,R), Board) :- valorF(1, s(F,R),Board,Valor),Valor==true.

% Para definir el nodo inicial a partir del tamaño del tablero, N, y una
% casilla desde la que el caballo inicia su recorrido, s(F,R),en un
% tablero vacío
initBoard(N, s(F,R), Node) :- tableroVacio(N, Board), validSquare(N,s(F,R),Board,NewBoard),createNode(node(N,1,NewBoard,s(F,R),[s(F,R)]),Node).

% Función principal, que recibe un entero representando el tamaño del
% tablero, una casilla desde la que el caballo iniciará su recorrido y
% devuelve un camino que recorre todo el tablero comenzando por la
% casilla indicada, si no hubiera solución, el camino devueltro sería
% vacío
knightTravel(N,s(F,R)):- initBoard(N,s(F,R),node(N,1,Board,s(F,R),[s(F,R)])), recorrerBT(node(N,1,Board,s(F,R),[s(F,R)])); solucion(node(0,0,[[]],s(0,0),[])).

% Implementa la búsqueda de soluciones en profundudad con vuelta atrás
% con una la llamada recursiva. Siendo la condición de parada,
% encontrar un nodo solución(fullPath)
recorrerBT(Node):- fullPath(Node),!, solution(Node).
recorrerBT(Node):- jump(Node,NNuevo), recorrerBT(NNuevo).

solucion(node(_,0,_,_,[])):- writeln([]).
solution(node(_,_,_,_,PInverse)):- reverse(PInverse, Path), writeln(Path).

% Construye un tablero vacío
tableroVacio(N,Board):- ct_aux(1,N,Board).
ct_aux(M,N,[]):- M > N, !.
ct_aux(M,N,[File|RF]):-  columnaVacia(N,File), M1 is M+1, ct_aux(M1,N,RF).

% Construye columnas vacías
columnaVacia(1,[true]):-!.
columnaVacia(N,[true|CV]):- N1 is N-1, columnaVacia(N1,CV).

% A partir de los datos necesarios construye un nodo
createNode(node(N,LP,Board,s(F,R),Path),node(N,LP,Board,s(F,R),Path)).

% Comprueba si el camino es completo
es_completo(node(N, Long_Path_recorrido, _, _, _))  :- T is N * N, T  =:= Long_Path_recorrido.

% Devuelve el valor de una casilla son valorF y valorR
valorF(F,s(F,R),[File|_],Valor):-!,valorR(1,R,File,Valor),!.
valorF(N,s(F,R),[_|RF],Valor):- N1 is N+1, valorF(N1,s(F,R),RF,Valor).

valorR(R,R, [Valor|_], Valor):-!.
valorR(N,R,[_|RR],Valor):- N1 is N + 1, valorR(N1,R,RR,Valor).

% Marca una casilla como visitada son VisitF y VisitR
visitF(_,[],[]):-!.
visitF(s(1,R), [C|RR],[C1|RR1]):- visitR(R,C,C1),visitF(s(0,R),RR,RR1),!.
visitF(s(F,R),[C|RR], [C|RR1]):- NextF is F-1, visitF(s(NextF,R),RR,RR1).

visitR(_,[],[]).
visitR(1, [_|RR], [false|RR1]):- visitR(0, RR, RR1),!.
visitR(R,[C|RR], [C|RR1]):- NextR is R-1, visitR(NextR,RR,RR1).

% Añade una casilla al final de la lista de casillas visitadasaddPath(P, [], [P]).
addPath(P, LP , [P|LP]).

% Genera un salto
% Actualiza la longitud del camino recorrido
% Actualiza el tablero marcando la casilla del salto como visitada
% Actualiza el camino añadiendo el salto
% Crea un nodo actualizado con los datos anteriores
jump(node(N,LPath, Board, s(F,R), Path), node(N, NextLPath, NewBoard, s(JF,JR), NewPath)):- NextLPath is LPath+1, jumps(s(F,R),s(JF,JR)), validSquare(N, s(JF,JR), Board, NewBoard),addPath(s(JF,JR),Path, NewPath).

% Movimientos del caballo a partir de una casilla
jumps(s(F,R),s(JF,JR)):- JF is F+2, JR is R+1.
jumps(s(F,R),s(JF,JR)):- JF is F+1, JR is R+2.
jumps(s(F,R),s(JF,JR)):- JF is F-1, JR is R+2.
jumps(s(F,R),s(JF,JR)):- JF is F-2, JR is R+1.
jumps(s(F,R),s(JF,JR)):- JF is F-2, JR is R-1.
jumps(s(F,R),s(JF,JR)):- JF is F-1, JR is R-2.
jumps(s(F,R),s(JF,JR)):- JF is F+1, JR is R-2.
jumps(s(F,R),s(JF,JR)):- JF is F+2, JR is R-1.