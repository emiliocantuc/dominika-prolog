% TABLERO
% Incluye funciones para administrar los extremos del tablero:
%   - hacerExtremo1/hacerExtremo2
%   - afuera
%   - nosotrosPonemos/contrincantePone
%   - revertirNuestraPuesta/revertirPuestaContrincante
%   - actualizarExtremos

% --------- SETTERS ---------------
% Para cambiar los extremos del tablero mientras cambia el juego

% Fija el extremo1 a A en la base de conocimientos dinamica.
% hacerExtremo1(i):
hacerExtremo1(A):-
    retractall(extremo1),
    asserta((extremo1(A):-!)).

% Fija el extremo2 a A en la base de conocimientos dinamica.
% hacerExtremo2(i):
hacerExtremo2(A):-
    retractall(extremo2),
    asserta((extremo2(A):-!)).


% -------- PONER EN TABLERO --------

% Determina el numero de "afuera" de una ficha dada la de adentro.
% afuera(i,i,o):
afuera(ficha(A,B),A,B):-!.
afuera(ficha(A,B),B,A):-!.

% Si podemos poner la ficha la eliminamos de misFichas y actualizamos los extremos.
% nosotrosPonemos(i,i):
nosotrosPonemos(ficha(A,B),Adentro):-
    puedePoner(ficha(A,B),Adentro), % verificar que si se pueda
    quitarMiFicha(ficha(A,B)),
    actualizarExtremos(ficha(A,B),Adentro),
    !.

% Si el contrincante puede poner la ficha la eliminamos de posiblesFichasContrincante,
% lasQueNoPudo, actualizamos los extremos, y sumamos 1 a nFichasContrincante.
% contrincantePone(i,i):
contrincantePone(ficha(A,B),Adentro):-
    puedePoner(ficha(A,B),Adentro), % verificar que si se pueda
    quitarFichaContrincante(ficha(A,B)),
    quitarDeLasQueNoPudo(ficha(A,B)),
    actualizarExtremos(ficha(A,B),Adentro),
    sumarFichasContrincante(-1),
    !.


% ---------- REVERTIR JUGADAS ----------

% A usar dentro del minimax. Deshacemos la ultima puesta de ficha (nuestra).
% Deja a los extremos y misFichas justo como estaban antes de tirar la ficha.
% revertirNuestraPuesta(i,i):
revertirNuestraPuesta(ficha(A,B),Adentro):-
    % La agregamos a mis fichas y actualizamos extremos
    insertarMiFicha(A,B),
    afuera(ficha(A,B),Adentro,Afuera),
    actualizarExtremos(ficha(A,B),Afuera).

% A usar dentro del minimax. Deshacemos la ultima puesta de ficha (contrincante).
% Deja los extremos y posiblesFichas justo como estaban antes de tirar la ficha.
% revertirPuestaContrincante(i,i):
revertirPuestaContrincante(ficha(A,B),Adentro):-
    insertarFichaContrincante(A,B),
    afuera(ficha(A,B),Adentro,Afuera),
    actualizarExtremos(ficha(A,B),Afuera),
    sumarFichasContrincante(1).

% -------- ACTUALIZAR EXTREMOS ---------

% Actualizar extremos. Se llaman cuando alguien pone o revierte una puesta.
% actualizarExtremos(i,i):

% Si el tablero esta vacio tenemos que hacer los extremos -1
actualizarExtremos(ficha(_,_),_):-
    misFichas(F),
    length(F,L),
    posiblesFichasContrincante(C),
    length(C,L2),
    L+L2=:=28,
    hacerExtremo1(-1),
    hacerExtremo2(-1),
    !.
% Cuando los extremos son -1 no hay fichas en el tablero.
% Hacemos a los extremos los lados A y B de la ficha.
actualizarExtremos(ficha(A,B),_):- 
    extremo1(X1),
    X1=:=(-1), 
    hacerExtremo1(A),
    hacerExtremo2(B),
    !.

% Si el extremo1 coincide con Adentro, reemplazamos extremo1 con afuera(ficha).
actualizarExtremos(ficha(A,B),Adentro):-
    extremo1(X1),
    X1=:=Adentro, 
    afuera(ficha(A,B),Adentro,Afuera),
    hacerExtremo1(Afuera),
    !.

% Si el extremo2 coincide con Adentro, reemplazamos extremo2 con afuera(ficha).
actualizarExtremos(ficha(A,B),Adentro):-
    extremo2(X2),
    X2=:=Adentro,
    afuera(ficha(A,B),Adentro,Afuera),
    hacerExtremo2(Afuera),
    !.


