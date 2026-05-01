% ============================================================
% orientador_logic.pl  -  Motor de Inferencia  |  OrientadorCE
% ============================================================
% Motor de scoring y recomendación - calcula qué carrera
% le conviene más al usuario según sus respuestas.

:- module(orientador_logic, [
    calcular_puntaje/4,
    puntajes_todas/3,
    calcular_y_recomendar/2,
    bono_entorno/3
]).

:- [orientador_bd].
:- use_module(library(lists)).

% PESOS - qué tan importante es cada tipo de coincidencia
% Ej: investigación vale 5 puntos, tecnología 4, arte 4, etc.
% ============================================================

peso(afinidad_investigacion, 5).
peso(afinidad_tecnologia,    4).
peso(afinidad_ciencia,      3).
peso(afinidad_arte,         4).
peso(afinidad_negocios,     4).
peso(afinidad_basica,       2).
peso(fortaleza_intelectual, 3).
peso(fortaleza_practica,    2).
peso(antagonia_negativa,    4).
peso(antagonia_positiva,    5).
peso(afinidad_negativa,     3).
peso(fortaleza_negativa,    1).

umbral_recomendacion(2).
margen_empate(3).

% ENTORNOS LABORALES - bonificación por palabras como "laboratorio", "NASA"
% Si el usuario menciona estos ambientes, suma puntos extra a ciertas carreras
% ============================================================

entorno_clave(laboratorio, [fisica, ingenieria_fisica, biologia, quimica, electronica, mecatronica], 4).
entorno_clave(investigacion, [fisica, ingenieria_fisica, biologia, quimica, sistemas, aeroespacial], 4).
entorno_clave(nasa, [aeroespacial, fisica, ingenieria_fisica], 6).
entorno_clave(espacio, [aeroespacial, fisica], 5).
entorno_clave(construccion, [civil, arquitectura], 4).
entorno_clave(obra, [civil, arquitectura], 4).
entorno_clave(pacientes, [medicina, psicologia], 5).
entorno_clave(hospital, [medicina, psicologia], 4).
entorno_clave(tecnologia, [sistemas, electronica, mecatronica], 3).
entorno_clave(robotica, [mecatronica, electronica, sistemas], 4).
entorno_clave(oficina, [administracion, derecho, sistemas], 4).
entorno_clave(empresa, [administracion, derecho, negocios], 5).
entorno_clave(negocios, [administracion, derecho], 4).
entorno_clave(emprendimiento, [administracion], 5).

% CÁLCULO DE PUNTAJE
% La fórmula matemática que da el puntaje a cada carrera
% Suma puntos por afinidades, resta por conflictos
% ============================================================

calcular_puntaje(Carrera, TPos, TNeg, PuntajeFinal) :-
    afinidades(Carrera, Afins),
    fortalezas(Carrera, Forts),
    antagonias(Carrera, Ants),

    % Categorizar afinidades
    categorize_afins(TPos, Afins, NAP_invest, NAP_tech, NAP_ciencia, NAP_arte, NAP_negocios, NAP_basica),

    % Fortalezas
    intersection(TPos, Forts, FP), length(FP, NFP),

    % Antagonías
    intersection(TNeg, Ants, AN), length(AN, NAN),

    % Conflictos (token positivo en antagonía o negativo en afinidad)
    intersection(TPos, Ants, APN), length(APN, NAPN),
    intersection(TNeg, Afins, AFN), length(AFN, NFN),
    intersection(TNeg, Forts, FFN), length(FFN, NFFN),

    % Nuevos pesos
    peso(afinidad_investigacion, W1),
    peso(afinidad_tecnologia,    W2),
    peso(afinidad_ciencia,      W3),
    peso(afinidad_arte,          W4),
    peso(afinidad_negocios,     W5),
    peso(afinidad_basica,       W6),
    peso(fortaleza_intelectual, W7),
    peso(antagonia_negativa,    W8),
    peso(antagonia_positiva,    W9),
    peso(afinidad_negativa,     W10),

    PuntajeBase is (NAP_invest * W1) + (NAP_tech * W2) + (NAP_ciencia * W3) + (NAP_arte * W4) + (NAP_negocios * W5) + (NAP_basica * W6)
                 + (NFP * W7) + (NAN * W8)
                 - (NAPN * W9) - (NFN * W10) - (NFFN * 1),

    % Bono por entorno laboral
    bono_entorno(TPos, Carrera, Bono),

    PuntajeFinal is PuntajeBase + Bono.

% Categorizar afinidades - separa los intereses en grupos
% Ej: si dice "investigación" va a grupo investigación, si dice "arte" va a arte
categorize_afins(Tokens, Afins, NInv, NTec, NCien, NArte, NNeg, NBas) :-
    findall(T, (member(T, Afins), member(T, Tokens), investigacion_token(T)), MatchingInv), length(MatchingInv, NInv),
    findall(T, (member(T, Afins), member(T, Tokens), tecnologia_token(T)), MatchingTec), length(MatchingTec, NTec),
    findall(T, (member(T, Afins), member(T, Tokens), ciencia_token(T)), MatchingCien), length(MatchingCien, NCien),
    findall(T, (member(T, Afins), member(T, Tokens), arte_token(T)), MatchingArte), length(MatchingArte, NArte),
    findall(T, (member(T, Afins), member(T, Tokens), negocios_token(T)), MatchingNeg), length(MatchingNeg, NNeg),
    findall(T, (member(T, Afins), member(T, Tokens), basica_token(T)), MatchingBas), length(MatchingBas, NBas).

% Tags para categorización
investigacion_token(investigacion).
investigacion_token(laboratorio).
investigacion_token(experimentacion).
investigacion_token(descubrimiento).
investigacion_token(teoria).
investigacion_token(modelado).
investigacion_token(simulacion).
investigacion_token(investigador).

tecnologia_token(tecnologia).
tecnologia_token(robotica).
tecnologia_token(automatizacion).
tecnologia_token(electronica).
tecnologia_token(circuitos).
tecnologia_token(sensores).
tecnologia_token(microcontrolador).
tecnologia_token(software).
tecnologia_token(programacion).
tecnologia_token(tecnologico).

ciencia_token(fisica).
ciencia_token(biologia).
ciencia_token(quimica).
ciencia_token(ciencia).
ciencia_token(matematicas).
ciencia_token(calculo).
ciencia_token(analisis).
ciencia_token(analitico).

arte_token(arte).
arte_token(artistico).
arte_token(arte_visual).
arte_token(disenio).
arte_token(diseno).
arte_token(estetica).
arte_token(color).
arte_token(visual).
arte_token(ilustracion).
arte_token(fotografia).
arte_token(pintura).
arte_token(dibujo).
arte_token(creativo).
arte_token(creativa).
arte_token(imaginativo).
arte_token(creatividad).
arte_token(cine).
arte_token(publicidad).

negocios_token(negocios).
negocios_token(negocio).
negocios_token(empresas).
negocios_token(empresa).
negocios_token(economia).
negocios_token(economico).
negocios_token(economica).
negocios_token(finanzas).
negocios_token(financiero).
negocios_token(financiera).
negocios_token(contaduria).
negocios_token(auditoria).
negocios_token(liderazgo).
negocios_token(lider).
negocios_token(estrategia).
negocios_token(gestion).
negocios_token(gestion_empresarial).
negocios_token(emprendimiento).
negocios_token(emprendedor).
negocios_token(emprendedora).
negocios_token(marketing).
negocios_token(ventas).
negocios_token(recursos_humanos).
negocios_token(rrhh).
negocios_token(operaciones).
negocios_token(logistica).

basica_token(matematicas).
basica_token(fisica).
basica_token(quimica).
basica_token(matematica).

% BONO POR ENTORNO LABORAL
% Suma puntos extra si el usuario menciona donde quiere trabajar
% Ej: "laboratorio" suma a Física, "NASA" suma a Aeroespacial
% ============================================================

bono_entorno(Tokens, Carrera, Bono) :-
    is_list(Tokens),
    entorno_clave(Clave, Carreras, Puntos),
    member(Clave, Tokens),
    member(Carrera, Carreras), !,
    Bono = Puntos.

bono_entorno(_, _, 0).

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
% DECISIÓN DE RECOMENDACIÓN MEJORADA
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

decidir([P1-C1, P2-C2 | _], TPos, _) :-
    P1 - P2 =< 2,
    bono_entorno(TPos, C1, B1),
    bono_entorno(TPos, C2, B2),
    (   B1 > B2
    ->  escribir_recomendacion(C1, P1, [P2-C2], TPos)
    ;   escribir_recomendacion(C2, P2, [P1-C1], TPos)
    ), !.

decidir([P1-C1 | Resto], TPos, _) :-
    escribir_recomendacion(C1, P1, Resto, TPos).

escribir_recomendacion(Carrera, Puntaje, Alternativas, _) :-
    nl, writeln('=========================================='),
    format('  RECOMENDACION: ~w~n', [Puntaje]),
    writeln('=========================================='),
    carrera(Carrera, Nombre, _),
    format('~n~w (Puntaje: ~w)~n~n', [Nombre, Puntaje]),
    writeln('--- ¿Por qué esta carrera? ---'),
    explicar_recomendacion(Carrera),
    (   Alternativas = [P2-C2 | _], P2 > 0
    ->  nl, writeln('--- Alternativa sugerida ---'),
        carrera(C2, Nombre2, _),
        format('~w (Puntaje: ~w)~n', [Nombre2, P2]),
        explicar_recomendacion(C2)
    ;   true
    ).

explicar_recomendacion(Carrera) :-
    afinidades(Carrera, Afins),
    fortalezas(Carrera, Forts),
    antagonias(Carrera, Ants),
    format('  Intereses relacionados: ~w~n', [Afins]),
    format('  Habilidades requeridas: ~w~n', [Forts]),
    format('  No es ideal para: ~w~n', [Ants]).