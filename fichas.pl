% FICHAS
% Incluye la lista de fichas y funciones para administrarlas:
%   - setMisFichas/setFichasContrincante/setMejorMovida
%   - insertarMiFicha/insertarFichaContrincante
%   - quitarMiFicha/quitarFichaContrincante
%   - puedePoner
%   - fichasQuePodemosPoner/fichasQueContrincantePuedePoner/fichasQueContrincantePuedePonerSinExtremos
%   - llenarFichasContrincante
%   - listaFichaExtremos
%   - fichaTieneNum


% ----- SETTERS ------
% Fija misFichas a una lista de fichas, Lm, en la base de conocimientos dinamica.
% setMisFichas(i):
setMisFichas(Lm):-
    retractall(misFichas),
    asserta(misFichas(Lm):-!),
    !.

% Fija posiblesFichasContrincante a una lista de fichas, Lc, en la base de conocimientos dinamica.
% setFichasContrincante(i):
setFichasContrincante(Lc):-
    retractall(posiblesFichasContrincante),
    asserta(posiblesFichasContrincante(Lc):-!),
    !.

% Fija setMejorMovida a una ficha y lado de adentro en la base de conocimientos dinamica.
% setMejorMovida(i):
setMejorMovida(ficha(A,B),Adentro):-
    retractall(mejorMovida),
    asserta((mejorMovida(ficha(A,B),Adentro):-!)).

%  ----- INSERTAR FICHAS ------
% Inserta una ficha a misFichas en la base de conocimientos dinamica.
% insertarMiFicha(i),insertarMiFicha(i,i):
insertarMiFicha(ficha(A,B)):-
    insertarMiFicha(A,B),
    !.
% Checa que A <= B.
insertarMiFicha(A,B):-
    A>B,
    write("ERROR: debe ser tal que ficha[0] <= ficha[1]."),nl,
    !.
% Checa que no tengamos esa ficha.
insertarMiFicha(A,B):-
    misFichas(Fichas),
    member(Fichas,ficha(A,B)),
    write("ERROR: ya tenemos esa ficha."),nl,
    !.
insertarMiFicha(A,B):-
    misFichas(FichasM),
    append(FichasM,[ficha(A,B)],Fm),
    setMisFichas(Fm),
    !.

% Inserta una ficha a posiblesFichasContrincante en la base de conocimientos dinamica.
% insertarFichaContrincante(i),insertarFichaContrincante(i,i):
% Checa que A <= B.
insertarFichaContrincante(A,B):-
    A>B,
    write("ERROR: debe ser tal que ficha[0] <= ficha[1]."),
    !.
% Checa que el contrincante todavia no tenga esa ficha.
insertarFichaContrincante(A,B):-
    posiblesFichasContrincante(Fichas),
    member(Fichas,ficha(A,B)),
    write("ERROR: ya tiene esa ficha"),
    !.
insertarFichaContrincante(A,B):-
    posiblesFichasContrincante(FichasC),
    append(FichasC,[ficha(A,B)],Fc),
    setFichasContrincante(Fc),
    !.

%  ----- QUITAR FICHAS ------
% Quita ficha de misFichas en la base de conocimientos dinamica.
% quitarMiFicha(i):
quitarMiFicha(ficha(A,B)):-
    misFichas(Fichas),
    delete(Fichas,ficha(A,B),FichasNuevas),
    retractall(misFichas),
    asserta(misFichas(FichasNuevas):-!).

% Quita ficha de posiblesFichasContrincante en la base de conocimientos dinamica.
% quitarFichaContrincante(i):
quitarFichaContrincante(ficha(A,B)):-
    posiblesFichasContrincante(Fichas),
    delete(Fichas,ficha(A,B),FichasNuevas),
    retractall(posiblesFichasContrincante),
    asserta(posiblesFichasContrincante(FichasNuevas):-!).

%  ----- PUEDE PONER ------
% Determina si podemos o no poner una ficha en el tablero con un lado "adentro".
% puedePoner(i),puedePoner(i,i),puedePoner([i,i]):

% Determina si se puede poner con cualquier lado "adentro".
puedePoner(ficha(A,B)):-
    puedePoner(ficha(A,B),A),
    !.
puedePoner(ficha(A,B)):-
    puedePoner(ficha(A,B),A),
    !.
puedePoner([ficha(A,B),Adentro]):-
    puedePoner(ficha(A,B),Adentro).

% Si no hay fichas en el tablero (extremos son -1), siempre se puede poner.
puedePoner(ficha(_,_),_):-
    extremo1(X1),
    X1=:=(-1),
    !.
% Si el extremo1 coincide con Adentro(A) se puede poner.
puedePoner(ficha(A,_),A):-
    extremo1(X1),
    A=:=X1,
    !.
% Si el extremo2 coincide con Adentro(A) se puede poner.
puedePoner(ficha(A,_),A):-
    extremo2(X2),
    A=:=X2,
    !.
% Si el extremo1 coincide con Adentro(B) se puede poner.
puedePoner(ficha(_,B),B):-
    extremo1(X1),
    B=:=X1,
    !.
% Si el extremo2 coincide con Adentro(B) se puede poner.
puedePoner(ficha(_,B),B):-
    extremo2(X2),
    B=:=X2,
    !.

%  ----- FICHAS QUE SE PUEDEN PONER ------
% Determina que fichas podemos poner en el tablero actual.
% PodemosPoner toma la forma de [[ficha(A,B),Adentro],[ficha(A,B),Adentro],...]
% fichasQuePodemosPoner(o):
fichasQuePodemosPoner(PodemosPoner):-
    misFichas(Fm),
    listaFichaExtremos(Fm,FichasConExtremos),
    include(puedePoner,FichasConExtremos,PodemosPoner).

% Determina que fichas puede poner el contrincante en el tablero actual.
% Puede toma la forma de [[ficha(A,B),Adentro],[ficha(A,B),Adentro],...]
% fichasQueContrincantePuedePoner(o):
fichasQueContrincantePuedePoner(Puede):-
    posiblesFichasContrincante(Fc),
    listaFichaExtremos(Fc,FichasConExtremos),
    include(puedePoner,FichasConExtremos,Puede).

% Determina que fichas puede poner el contrincante en el tablero actual.
% Puede toma la forma de [ficha(A,B),ficha(A,B),...]
% fichasQueContrincantePuedePoner(o):
fichasQueContrincantePuedePonerSinExtremos(Puede):-
    posiblesFichasContrincante(Fc),
    include(puedePoner,Fc,Puede).

% Checa si un elemento es miembro de una lista. 
% member(i,i):
member([X|_],X).
member([_|R],X) :- member(R,X).

%  ----- LLENAR CONTRINCANTE ------
% Llena posiblesFichasContrincante con todas las fichas que no pertenecen a misFichas.
% llenarFichasContrincante.
llenarFichasContrincante():-
    misFichas(Mis),
    fichas(Fichas),exclude(member(Mis),Fichas,Temp),
    asserta((posiblesFichasContrincante(Temp):-!)).

% ------ EXTREMOS DE FICHA --------
% Dada una lista de fichas construye una lista del tipo [[ficha(0,1),0],[ficha(0,1),1],...].
% listaFichaExtremos(i,o):
listaFichaExtremos([],[]):-!.
listaFichaExtremos([ficha(A,A)|Resto],Res):- %es mula
    listaFichaExtremos(Resto,Temp),
    append(Temp,[[ficha(A,A),A]],Res),
    !.
listaFichaExtremos([ficha(A,B)|Resto],Res):- %no es mula
    listaFichaExtremos(Resto,Temp),
    append(Temp,[[ficha(A,B),A],[ficha(A,B),B]],Res),
    !.

% ------ FICHA TIENE ------
% Checa si la ficha contiene un numero.
% fichaTieneNum(i,i):
fichaTieneNum(A,ficha(A,_)):-!.
fichaTieneNum(B,ficha(_,B)):-!.

%  ----- LISTA DE FICHAS ------
% Las 28 fichas. Son tales que ficha[0]<=ficha[1].
fichas([
    ficha(0,0),
    ficha(0,1),
    ficha(0,2),
    ficha(0,3),
    ficha(0,4),
    ficha(0,5),
    ficha(0,6),
    ficha(1,1),
    ficha(1,2),
    ficha(1,3),
    ficha(1,4),
    ficha(1,5),
    ficha(1,6),
    ficha(2,2),
    ficha(2,3),
    ficha(2,4),
    ficha(2,5),
    ficha(2,6),
    ficha(3,3),
    ficha(3,4),
    ficha(3,5),
    ficha(3,6),
    ficha(4,4),
    ficha(4,5),
    ficha(4,6),
    ficha(5,5),
    ficha(5,6),
    ficha(6,6)
]):-!.
