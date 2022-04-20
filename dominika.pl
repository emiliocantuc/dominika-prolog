% --------------------------------------------------------------------------------
%                                   DOMINIKA
%
%                                     USO
%
% Para cada juego hacer una nueva consulta, correr `juego.` y seguir los prompts.
% En nuestros turnos correr `juega.`. Si el resultado es "Comemos o pasamos" 
% y podemos comer correr `comemos.`
% En los turnos del contrincante correr `contrincante.` y seguir los prompts. 
% NOTA: Fichas simpre se insertan tal que lado 1 <= segundo lado.
%
% --------------------------------------------------------------------------------          

library(lists).
library(apply).

:- dynamic misFichas /1. % Las fichas que tenemos nosotros.
:- dynamic posiblesFichasContrincante /1. % Las fichas que puede tener el contrincante.
:- dynamic lasQueNoPudo /1. % Fichas que quitamos de posiblesFichas en la comida anterior.
:- dynamic nFichasContrincante /1. %El no. de fichas que sabemos que tiene el contrincante.
:- dynamic extremo1 /1. % Un extremo (numero en la orilla) del tablero.
:- dynamic extremo2 /1. % Otro extremo del tablero.

:- dynamic mejorMovida /2. % La mejor movida para MAX (nosotros) encontrada en el minimax.

% Consultamos los demas archivos.
:- [fichas,creencias,tablero,utils].

misFichas([]):-!. % Nuestras fichas durante el juego.
posiblesFichasContrincante([]):-!. % Las fichas del contrincante durante el juego.
nFichasContrincante(7):-!. % Contrincante siempre empieza con 7 fichas
lasQueNoPudo([]):-!. % Fichas que quitamos de posiblesFichas en la comida anterior.

maxProfundidad(7):-!. % La profundidad a la cual aplicar la heuristica en el MINIMAX.

mejorMovida(ficha(-1,-1),-1):-!. % La mejor movida para MAX encontrada durante el MINIMAX.

extremo1(-1):-!. % -1 Indica que los extremos empiezan vacios.
extremo2(-1):-!.


% -------- JUEGA --------
% Determina que accion toma el agente durante su turno.
% juega, juega(i).
% Funcion wrapper a usar en la interface. 
juega():-
    fichasQuePodemosPoner(Disp),
    juega(Disp).
% Si no tenemos fichas para poner comemos o pasamos.
juega([]):- 
    write('Come o pasa'),
    !.
% Si solo tenemos una ficha para poner la ponemos.
juega([[ficha(A,B),Adentro]]):- 
    write('Poner '),
    imprimeFicha(ficha(A,B),Adentro),write(" (unica opcion)"),nl,
    nosotrosPonemos(ficha(A,B),Adentro),
    !.
% Si solo tenemos mas de una ficha para poner realizamos minimax y
% jugamos la mejor jugada encontrada.
juega([[ficha(A,B),Adentro]|_]):-
    %actualizarMejorMovida(0,1,0,ficha(A,B),Adentro),
    maxValue(0,1,0,M,false),
    mejorMovida(ficha(A,B),Adentro),
    write('Poner '),imprimeFicha(ficha(A,B),Adentro),
    write(' (valor: '),write(M),write(')'),nl,
    nosotrosPonemos(ficha(A,B),Adentro),
    !.

% --------- MAX VALUE ------------
% El valor minimax para MAX como funcion de Alpha, Beta, Profundidad y si el AnteriorPaso.
% maxValue(i,i,i,o,i):
maxValue(_,_,Profundidad,Res,AnteriorPaso):-
    fichasQuePodemosPoner(Disp),
    terminalTest(Disp,Profundidad,Res,AnteriorPaso), % Checamos si paramos la busqueda
    !.
maxValue(Alpha,Beta,Profundidad,Res,_):-
    fichasQuePodemosPoner(Disp),
    length(Disp,L),
    ProfundidadTemp is Profundidad+1,
    (
        % Si no tenemos para poner (y el anterior no paso - terminalTest), pasamos.
        L=:=0 -> minValue(Alpha,Beta,ProfundidadTemp,Res,true);
        maxValue(Disp,0,Alpha,Beta,Profundidad,Res)
    ),
    !.
% Llegamos al final de los disponibles. Resp es V.
maxValue([],V,_,_,_,V):-!. 
maxValue([[ficha(A,B),Adentro]|Resto],V,Alpha,Beta,Profundidad,Res):-
    nosotrosPonemos(ficha(A,B),Adentro), % Ponemos la ficha
    ProfundidadTemp is (Profundidad+1),
    minValue(Alpha,Beta,ProfundidadTemp,Temp,false), % Guardamos el valor minimax MIN en Temp
    revertirNuestraPuesta(ficha(A,B),Adentro), % Revertimos la puesta
    Vtemp is max(V,Temp), % Actualizamos el valor de V
    actualizarMejorMovida(Profundidad,Temp,V,ficha(A,B),Adentro), % Actualizamos la mejor movida para MAX
    (
        % Si V>=Beta "regresamos" V y si no ponemos la siguiente ficha disponible.
        Vtemp>=Beta -> Res is Vtemp;
        AlphaTemp is max(Alpha,Vtemp),
        maxValue(Resto,Vtemp,AlphaTemp,Beta,Profundidad,Res)
    ),
    !. 

% Actualiza el valor de mejorMovida en la base de conocimientos dinamica
% si Profundidad = 0 y Temp > V.
% actualizarMejorMovida(i,i,i,i,i):
actualizarMejorMovida(Profundidad,Temp,V,ficha(A,B),Adentro):-
    Profundidad=:=0,
    imprimeFicha(ficha(A,B),Adentro),write(" temp:"),write(Temp),write(" v:"),write(V),nl,
    Temp>=V,
    setMejorMovida(ficha(A,B),Adentro),
    !.
actualizarMejorMovida(_,_,_,_,_):-!.

% --------- MIN VALUE -------------
% El valor minimax para MIN como funcion de Alpha, Beta, Profundidad y si el AnteriorPaso.
% minValue(i,i,i,o,i):
minValue(_,_,Profundidad,Res,AnteriorPaso):-
    fichasQueContrincantePuedePoner(Disp),
    terminalTest(Disp,Profundidad,Res,AnteriorPaso), % Checamos si paramos la busqueda
    !.
minValue(Alpha,Beta,Profundidad,Res,_):-
    fichasQueContrincantePuedePoner(Disp),
    length(Disp,L),
    ProfundidadTemp is Profundidad+1,
    (
        % Si no podemos poner (y el anterior no paso - terminalTest), pasamos.
        L=:=0 -> maxValue(Alpha,Beta,ProfundidadTemp,Res,true);
        minValue(Disp,1,Alpha,Beta,Profundidad,Res)
    ),
    !.
% Llegamos al final de los disponibles. Res es V.
minValue([],V,_,_,_,V):-!. 
minValue([[ficha(A,B),Adentro]|Resto],V,Alpha,Beta,Profundidad,Res):-
    contrincantePone(ficha(A,B),Adentro), % Ponemos ficha.
    ProfundidadTemp is (Profundidad+1),
    maxValue(Alpha,Beta,ProfundidadTemp,Temp,false), % Guardamos el valor minimax para MAX en Temp.
    revertirPuestaContrincante(ficha(A,B),Adentro), % Revertimos la puesta.
    Vtemp is min(V,Temp), % Actualizamos el valor de V.
    (
        % Si V <= Alpha, "regresa" V. Si no, itera con la siguiente ficha disponible.
        Vtemp=<Alpha -> Res is Vtemp ;
        BetaTemp is min(Beta,Vtemp),
        minValue(Resto,Vtemp,Alpha,BetaTemp,Profundidad,Res)
    ),
    !. 

% -------- TERMINAL TEST Y UTLITY --------
% Determina si paramos la busqueda y la utilidad de ser el caso.
% terminalTest(i,i,o,i):
% Si llegamos a la profundidad maxima terminamos la busqueda y aplicamos la heuristica.
terminalTest(_,Profundidad,Res,_):-
    maxProfundidad(M),
    Profundidad>=M,
    heuristica(Profundidad,Res),
    !.
% Si ya no tenemos fichas ganamos y la utilidad es 1.
terminalTest(_,_,Res,_):-
    misFichas(F),
    length(F,L),
    L=:=0, %ganamos
    Res is 1, %la utilidad es 1
    !. 
% Si el contrincante ya no tiene fichas perdemos y la utilidad es 0.
terminalTest(_,_,Res,_):-
    nFichasContrincante(L),
    L=:=0, %perdimos
    Res is 0, 
    !.
% Si no tenemos para poner y el anterior paso empatamos y la utilidad es 0.5
terminalTest([],_,Res,true):-
    Res is 0.5, % empate
    !.
% Si no tenemos para poner y el anterior no paso y todavia hay fichas en el pozo
% deberiamos de tomar del pozo (hacer simulaciones), pero en Dominika aplicamos la heuristica.
terminalTest([],Profundidad,Res,false):- 
    posiblesFichasContrincante(Posibles),
    length(Posibles,Npos),
    nFichasContrincante(N),
    FichasEnPozo is (Npos-N),
    FichasEnPozo>0,
    heuristica(Profundidad,Res), % En lugar de pasar aplicamos heuristica.
    !.


% --------- HEURISTICA -----------
% La funcion heuristica.
% heuristica(i,i):
heuristica(_,Res):-
    misFichas(Mis),
    nFichasContrincante(Lc),
    length(Mis,Lm),
    Res is (Lm/(Lm+Lc)). 



