% ============================================================
% orientador_logic.pl  -  Motor de Inferencia  |  OrientadorCE
% ============================================================
%
% Motor de scoring y recomendación de carreras.
% ============================================================

:- module(orientador_logic, [
    calcular_puntaje/4,
    puntajes_todas/3,
    calcular_y_recomendar/2
]).

:- [orientador_bd].
:- use_module(library(lists)).

% ============================================================
% PARÁMETROS
% ============================================================

peso(afinidad_positiva,   3).
peso(fortaleza_positiva,  2).
peso(antagonia_negativa,  2).
peso(antagonia_positiva,  3).
peso(afinidad_negativa,   2).
peso(fortaleza_negativa,  1).

umbral_recomendacion(3).
margen_empate(2).

% ============================================================
% CÁLCULO DE PUNTAJE
% ============================================================

calcular_puntaje(Carrera, TPos, TNeg, Puntaje) :-
    afinidades(Carrera, Afins),
    fortalezas(Carrera, Forts),
    antagonias(Carrera, Ants),

    intersection(TPos, Afins,  AP), length(AP, NAP),
    intersection(TPos, Forts,  FP), length(FP, NFP),
    intersection(TNeg, Ants,   AN), length(AN, NAN),

    intersection(TPos, Ants,  APN), length(APN, NAPN),
    intersection(TNeg, Afins,  AFN), length(AFN, NFN),
    intersection(TNeg, Forts,  FFN), length(FFN, NFFN),

    peso(afinidad_positiva,   W1),
    peso(fortaleza_positiva,  W2),
    peso(antagonia_negativa,  W3),
    peso(antagonia_positiva,  W4),
    peso(afinidad_negativa,   W5),
    peso(fortaleza_negativa,  W6),

    Puntaje is (NAP * W1) + (NFP * W2) + (NAN * W3)
             - (NAPN * W4) - (NFN * W5) - (NFFN * W6).

% ============================================================
% RANKING DE CARRERAS
% ============================================================

puntajes_todas(TPos, TNeg, ListaDesc) :-
    findall(P-C,
            (carrera(C, _, _), calcular_puntaje(C, TPos, TNeg, P)),
            Lista),
    msort(Lista, Asc),
    reverse(Asc, ListaDesc).

% ============================================================
% DECISIÓN DE RECOMENDACIÓN
% ============================================================

calcular_y_recomendar(TPos, TNeg) :-
    (   TPos = [], TNeg = []
    ->  writeln('Sin coincidencias: no se detectaron keywords')
    ;   puntajes_todas(TPos, TNeg, Ranking),
        decidir(Ranking, TPos, TNeg)
    ).

decidir([], _, _) :- !,
    writeln('Sin coincidencias.').

decidir([P1-_ | _], _, _) :-
    P1 =< 0, !,
    writeln('Sin coincidencias: puntaje no positivo.').

decidir([P1-C1, P2-C2 | _], _, _) :-
    umbral_recomendacion(Umbral),
    margen_empate(Delta),
    P2 >= Umbral,
    P1 - P2 =< Delta, !,
    carrera(C1, N1, _),
    carrera(C2, N2, _),
    format('Recomendacion doble: ~w y ~w~n', [N1, N2]),
    writeln('--- Detalles primera opcion ---'), explicar_recomendacion(C1),
    writeln('--- Detalles segunda opcion ---'), explicar_recomendacion(C2).

decidir([P1-C1 | _], _, _) :-
    carrera(C1, N1, Desc),
    format('Recomendacion: ~w~n~w~nPuntaje: ~w~n', [N1, Desc, P1]),
    nl, writeln('--- Detalles de la carrera ---'),
    explicar_recomendacion(C1).

% ============================================================
% EXPLICACIÓN DE RECOMENDACIÓN
% ============================================================

explicar_recomendacion(Carrera) :-
    afinidades(Carrera, Afins),
    fortalezas(Carrera, Forts),
    antagonias(Carrera, Ants),
    format('  Intereses   : ~w~n', [Afins]),
    format('  Habilidades: ~w~n', [Forts]),
    format('  No favor   : ~w~n', [Ants]).