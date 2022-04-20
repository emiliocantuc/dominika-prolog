% CREENCIAS
% Incluye funciones para administrar nuestras creencias sobre las fichas del contrincante.
% Es decir, funciones que administran nFichasContrincanet,lasQueNoPudo y posiblesFichasContrincante:
%   - setLasQueNoPudo/quitarDeLasQueNoPudo
%   - sumarFichasContrincante
%   - nosotrosComemeos
%   - contrincanteCome

% ------ SETTERS --------
% Modifica la base de datos dinamica para fijar lasQueNoPudo con Nuevas.
% setLasQueNoPudo(i):
setLasQueNoPudo(Nuevas):-
    retractall(lasQueNoPudo),
    asserta((lasQueNoPudo(Nuevas):-!)).

% Elimina la ficha(A,B) de las que no pudo.
% quitarDeLasQueNoPudo(i):
quitarDeLasQueNoPudo(ficha(A,B)):-
    lasQueNoPudo(L),
    delete(L,ficha(A,B),Lnueva),
    setLasQueNoPudo(Lnueva),
    !.

% Le suma Cuanto (que puede ser positivo o negativo) a nFichasContrincante.
% sumarFichasContrincante(i):
sumarFichasContrincante(Cuanto):-
    nFichasContrincante(N),
    Temp is N+Cuanto,
    retractall(nFichasContrincante),
    asserta((nFichasContrincante(Temp):-!)).

% ------- COMIDAS ---------

% Insertar ficha a mis fichas y quitar de posiblesFichasContrincante y de lasQueNoPudo.
% nosotrosComemos(i):
nosotrosComemos(ficha(A,B)):-
    insertarMiFicha(A,B),
    quitarDeLasQueNoPudo(ficha(A,B)),
    quitarFichaContrincante(ficha(A,B)). 

% Si el contrincante se queda con por lo menos una ficha, puede que haya comido una ficha
% previamente eliminada. Entonces agregamos lasQueNoPudo a posiblesFichasContrincante.
% Cuando el contrincante no tiene para poner no puede tener las fichas que se podrian poner.
% Eliminamos estas fichas de posiblesFichasContrincante y las guardamos en lasQueNoPudo.
% contrincanteCome(i):
contrincanteCome(CuantasSeQueda):-
    CuantasSeQueda>0,  %Si se queda con por lo menos una hacer lo siguiente
    posiblesFichasContrincante(Fichas),
    lasQueNoPudo(LasQueNoPasada),
    append(Fichas,LasQueNoPasada,Temp),
    setFichasContrincante(Temp), %Le agregamos lasQueNoPudo anterior a las fichasPosibles del contrincante
    fichasQueContrincantePuedePonerSinExtremos(Aquitar),
    exclude(member(Aquitar),Temp,Nuevas),
    setFichasContrincante(Nuevas),
    setLasQueNoPudo(Aquitar),
    sumarFichasContrincante(CuantasSeQueda),
    !.
%Si no se queda con ninguna solo agregamos fichasQueContrincantePuedePoner a lasQueNoPudo.
contrincanteCome(CuantasSeQueda):-
    sumarFichasContrincante(CuantasSeQueda),  
    posiblesFichasContrincante(Fichas),
    fichasQueContrincantePuedePonerSinExtremos(Aquitar),
    exclude(member(Aquitar),Fichas,Nuevas),
    setFichasContrincante(Nuevas),
    lasQueNoPudo(LasQueNoPasada),
    append(Aquitar,LasQueNoPasada,Temp),
    setLasQueNoPudo(Temp),
    sumarFichasContrincante(CuantasSeQueda),
    !.
