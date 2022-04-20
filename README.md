# Dominika
Una implementación en Prolog de minimax alfa-beta para jugar *Dominó Draw* de 2 jugadores. 

Proyecto para la materia de COM-23101 Inteligencia Artificial, Enero 2022, ITAM. Desarrollada y probada con SWI-Prolog versión 8.4.1.

## Versión de dominó
La versión de dominó de 2 jugadores a jugar es [*Dominó Draw*](https://www.dominorules.com/draw) sin *bluff*. En esta versión del juego, cada jugador empieza con 7 fichas y cuando un jugador no tiene fichas para poner tiene que tomar del “pozo” hasta que tome una que pueda poner. Los jugadores solo observan sus fichas y las fichas ya puestas y solo existen 2 “extremos” donde se pueden colocar fichas en el juego.

Las reglas hacen a esta versión de dominó un juego de dos jugadores, *zero sum*, estocástico (debido al reparto inicial de fichas y las tomadas del pozo) y de información incompleta (debido a no conocer las fichas del contrincante o del pozo). 

## Estrategia
La estrategia que emplea nuestro agente es relativamente sencilla. Se asume que MIN (el contrincante) puede puede poner cualquiera de las fichas posibles que puede tener en cualquier momento del juego. Con esta suposición, hacemos minimax alfa-beta hasta una profundidad máxima o hasta que MAX o MIN tengan que comer y aplicamos una función heurística para aproximar el valor minimax.  

La heurística empleada es simplemente 1 - m/(m+c) donde m es la cantidad de fichas que tiene nuestro agente y c la cantidad que tiene el contrincante.

El agente es solamente una demostración de la implementación de minimax alfa-beta en Prolog, por lo que existen muchas mejoras en su estrategia.  

## Instrucciones de uso
Para jugar contra el agente se debe consultar el archivo dominika.pl y realizar la consulta `juego.` y seguir los prompts para ingresar las fichas del agente (no las del contrincante, que no se conocen).

Para ingresar acciones del contrincante consultar `contrincante.` y seguir los prompts. 

Para determinar las acciones del agente consultar `juega.` y `comemos.` si el agente debe comer del pozo.  

**NOTA:** Las fichas siempre se deben insertar tal que primer lado <= segundo lado. El lado de “adentro” indica el lado de la ficha que coincide con alguno de los extremos del juego.  
