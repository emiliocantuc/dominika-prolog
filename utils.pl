% UTILS
% Incluyen funciones utilies y la interface para jugar:
%   - todo
%   - imprimeFicha
%   - preguntarPorMisFichas
%   - comemos/ponemosDespues/preguntarPorMisFichasComidas
%   - juego/primeraJugadaCont/primeraJugadaNosotros
%   - contrincante/accionContrincante

% --------- IMPRESIONES -------------
% Imprime el estado actual del juego.
% todo.
todo():-
    misFichas(F),
    posiblesFichasContrincante(Fc),
    lasQueNoPudo(Np),
    nl,
    write("Mis Fichas "),length(F,L1),write("("),write(L1),write("): "),write(F),nl,
    write("Posibles del contrincante: "),
    length(Fc,L2),write("("),write(L2),write("): "),write(Fc),nl,
    write("nFichasContrincante: "),nFichasContrincante(N),write(N),nl,
    write("lasQueNoPudo: "),write(Np),nl,
    write("Extremo 1: "),extremo1(X1),write(X1),nl,
    write("Extremo 2: "),extremo2(X2),write(X2),nl,nl.

% Imprime una ficha.
% imprimeFicha(i):
imprimeFicha(ficha(A,B)):-
    write("Ficha: "),
    write(A),write(","),
    write(B).
% Imprime una ficha y su lado de "adentro".
% imprimeFicha(i,i):
imprimeFicha(ficha(A,B),Adentro):-
    imprimeFicha(ficha(A,B)),
    write(" con adentro: "),
    write(Adentro).

% ------------- INTERFACE -----------------
% Funciones para interactuar con el programa durante un juego. 

% -------- PREGUNTAR POR MIS FICHAS -------
% Pregunta por I fichas al usuario y las inserta en misFichas.
% preguntarPorMisFichas(i):
preguntarPorMisFichas(0):-!.
preguntarPorMisFichas(I):-
    write("Ficha "),write(I),write(" a insertar."),nl,nl,
    write("\tPrimer lado: "),read(A),nl,
    write("\tSegundo lado: "),read(B),nl,
    insertarMiFicha(A,B),
    Temp is I-1,
    preguntarPorMisFichas(Temp),
    !.
% -------- PREGUNTAR POR MIS FICHAS COMIDAS -------
% Pregunta cuantas fichas comemos, cuales, las inserta y pregunta si ponemos despues de comer.
% comemos.
comemos:-
    write("Cuantas fichas comimos? "),read(Cuantas),nl,
    write("Ok inserta las fichas comidas."),nl,
    preguntarPorMisFichasComidas(Cuantas),nl,
    write("Ponemos despeus de comer? (y/n):"),
    read(PodemosDespues),
    ponemosDespues(PodemosDespues),
    !.
% Si ponemos despues de comer, pregutamos cual y la ponemos.
% ponemosDespues(i):
ponemosDespues('y'):-
    write("Inserta la ficha  a jugar despues de comer."),nl,nl,
    write("\tPrimer lado: "),read(A),nl,
    write("\tSegundo lado: "),read(B),nl,
    write("\tCon que numero adentro: "),read(Adentro),
    nosotrosPonemos(ficha(A,B),Adentro),
    !.
ponemosDespues(_):-!.

% Pregunta por las fichas que comemos y llama nosotrosComemos.
% preguntarPorMisFichasComidas(i):
preguntarPorMisFichasComidas(0):-!.
preguntarPorMisFichasComidas(I):-
    write("Ficha "),write(I),write(" a insertar."),nl,nl,
    write("\tPrimer lado: "),read(A),nl,
    write("\tSegundo lado: "),read(B),nl,
    nosotrosComemos(ficha(A,B)),
    Temp is I-1,
    preguntarPorMisFichasComidas(Temp),
    !.


% --------------- JUEGO ------------------
% Configura el inicio de un juego nuevo.
% Nos pregunta por nuestras fichas, llena las del contrincante y
% si el contrincante empieza.
juego:-
    write("NUEVO JUEGO\n\nIngresa nuestras 7 fichas:\n"),nl,
    preguntarPorMisFichas(7),
    llenarFichasContrincante(),
    write("Empieza contrincante? (y/n): "),read(EmpiezaCont),
    primeraJugadaCont(EmpiezaCont),
    todo().
juego.
% Si el contrincante juega primero ponemos la ficha que juega.
% primeraJugadaCont(i):
primeraJugadaCont('y'):-
    write("Inserta la ficha que el cont. juega en el primer turno."),nl,
    write("\tPrimer lado: "),read(A),nl,
    write("\tSegundo lado: "),read(B),nl,
    contrincantePone(ficha(A,B),A),
    !.
primeraJugadaCont('n'):-
    write("Empezamos nosotros con movida forzada (mula mas alta, etc.)? (y/n): "),read(EmpiezoForzado),
    primeraJugadaNosotros(EmpiezoForzado),
    !.

% Si nosotros empezamos con jugada forzada (por mula mas alta, etc.),
% preguntamos por la ficha y la jugamos.
% primeraJugadaNosotros(i):
primeraJugadaNosotros('y'):-
    write("Inserta la ficha que tenemos que jugar."),nl,
    write("\tPrimer lado: "),read(A),nl,
    write("\tSegundo lado: "),read(B),nl,
    nosotrosPonemos(ficha(A,B),A),
    !.
primeraJugadaNosotros('y'):-!.

% ---------- CONTRINCANTE ----------
% Pregunta que accion realiza el contrincante
contrincante:-
    write("Que hace el contrincante (juega/come/pasa): "),
    read(Accion),
    accionContrincante(Accion).
contrincante.

% Actualizaciones a realizar si contrincante juega/come/pasa.
% accionContrincante(i):
accionContrincante('juega'):-
    write("Inserta la ficha que el cont. juega."),nl,
    write("\tPrimer lado: "),read(A),nl,
    write("\tSegundo lado: "),read(B),nl,
    write("\tLado que pone adentro: "),read(Adentro),nl,
    contrincantePone(ficha(A,B),Adentro),
    !.
accionContrincante('come'):-
    write("Con cuantas fichas come el contrincante en TOTAL? "),nl,
    read(Cuantas),
    contrincanteCome(Cuantas),
    write("Tira despues de comer? (y/n): "),nl,
    read(Tira),
    contrincanteTira(Tira),
    !.
accionContrincante('pasa'):-
    write("Ok contrincante pasa"),nl,
    contrincanteCome(0),
    !.
contrincanteTira('y'):-
    accionContrincante('juega'),
    !.



