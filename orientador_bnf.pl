% ============================================================
% orientador_bnf.pl  –  Parser de Lenguaje Natural  |  OrientadorCE
% ============================================================
%
% Módulo de parsing con DCG real usando --> y phrase/2.
% ============================================================

:- module(orientador_bnf, [
    tokenizar/2,
    sinonimo/2,
    parsear_respuesta/3,
    dcg_intencion/2
]).

:- use_module(library(lists)).

% -------------------------------------------------
% TOKENIZADOR
% -------------------------------------------------

tokenizar(Linea, Tokens) :-
    atom_string(Linea, Str),
    string_lower(Str, Lower),
    split_string(Lower, " ,;.:!?()/\\\"'-", "", Partes),
    include([P]>>(P \= ""), Partes, Tokens).

% ============================================================
% GRAMÁTICA DCG CON -->
% Se ejecuta con phrase/2
% ============================================================

oracion --> sintagma_nominal, sintagma_verbal.
oracion --> sintagma_verbal.

sintagma_nominal --> pronombre.
sintagma_nominal --> determinante, sustantivo.
sintagma_nominal --> adjetivo, sustantivo.
sintagma_nominal --> sustantivo.
sintagma_nominal --> [].

sintagma_verbal --> verbo, complemento.
sintagma_verbal --> verbo.
sintagma_verbal --> enlace, sintagma_verbal.

complemento --> sintagma_nominal.
complemento --> preposicion, sustantivo.

sustantivo --> [programacion].
sustantivo --> [tecnologia].
sustantivo --> [matematicas].
sustantivo --> [arte].
sustantivo --> [fisica].
sustantivo --> [biologia].
sustantivo --> [personas].
sustantivo --> [computadoras].
sustantivo --> [ideas].
sustantivo --> [naturaleza].

pronombre --> [yo].
pronombre --> [me].

determinante --> [el].
determinante --> [la].
determinante --> [los].
determinante --> [las].

adjetivo --> [creativo].
adjetivo --> [artistico].
adjetivo --> [analitico].
adjetivo --> [social].

verbo --> [gusta].
verbo --> [gustan].
verbo --> [encanta].
verbo --> [apasiona].
verbo --> [interesa].
verbo --> [prefiero].

preposicion --> [con].
preposicion --> [en].
preposicion --> [para].

nexo --> [y].
nexo --> [mas].
nexo --> [pero].

enlace --> [pero, no].
enlace --> [aunque, no].

% ============================================================
% MARCADORES DCG
% ============================================================

marcador_positivo --> [me, gusta], !.
marcador_positivo --> [me, gusta, mucho], !.
marcador_positivo --> [me, encanta], !.
marcador_positivo --> [me, apasiona], !.
marcador_positivo --> [me, interesa], !.
marcador_positivo --> [soy], !.
marcador_positivo --> [soy, bueno], !.
marcador_positivo --> [soy, buena], !.
marcador_positivo --> [prefiero], !.
marcador_positivo --> [disfruto], !.
marcador_positivo --> [amo], !.
marcador_positivo --> [tengo, facilidad], !.

marcador_negativo --> [no, me, gusta], !.
marcador_negativo --> [no, me, interesa], !.
marcador_negativo --> [me, cuesta], !.
marcador_negativo --> [me, aburre], !.
marcador_negativo --> [odio], !.
marcador_negativo --> [detesto], !.
marcador_negativo --> [evito], !.
marcador_negativo --> [nunca], !.
marcador_negativo --> [ni], !.
marcador_negativo --> [tampoco], !.
marcador_negativo --> [pero, no], !.

% ============================================================
% INTERFAZ DCG PÚBLICA
% ============================================================

dcg_intencion(Tokens, Intencion) :-
    (phrase(marcador_positivo, Tokens, _Resto)
    -> Intencion = positivo
    ; phrase(marcador_negativo, Tokens, _Resto)
    -> Intencion = negativo
    ; Intencion = indefinido
    ).

% ============================================================
% PARSER PRINCIPAL
% ============================================================

parsear_respuesta(Linea, TokensPos, TokensNeg) :-
    tokenizar(Linea, Tokens),
    dcg_intencion(Tokens, _IntencionDCG),
    analizar(Tokens, positivo, Pares),
    separar_pares(Pares, PosRaw, NegRaw),
    list_to_set(PosRaw, TokensPos),
    list_to_set(NegRaw, TokensNeg).

analizar([], _, []).
analizar(Tokens, _, Pares) :-
    detectar_marcador(Tokens, NuevaPol, Resto), !,
    analizar(Resto, NuevaPol, Pares).
analizar([W1, W2 | Resto], Pol, [(K, Pol) | Pares]) :-
    sinonimo(W1, K1), sinonimo(W2, K2),
    (   K1 = K2 -> K = K1
    ;   atom_concat(K1, '_', Aux), atom_concat(Aux, K2, K)
    ),
    sinonimo(K, _), !,
    analizar(Resto, Pol, Pares).
analizar([W | Resto], Pol, [(K, Pol) | Pares]) :-
    sinonimo(W, K), !,
    analizar(Resto, Pol, Pares).
analizar([_ | Resto], Pol, Pares) :-
    analizar(Resto, Pol, Pares).

detectar_marcador([me, gusta | R], positivo, R) :- !.
detectar_marcador([me, gusta, mucho | R], positivo, R) :- !.
detectar_marcador([me, encanta | R], positivo, R) :- !.
detectar_marcador([me, apasiona | R], positivo, R) :- !.
detectar_marcador([me, interesa | R], positivo, R) :- !.
detectar_marcador([soy | R], positivo, R) :- !.
detectar_marcador([soy, bueno | R], positivo, R) :- !.
detectar_marcador([soy, buena | R], positivo, R) :- !.
detectar_marcador([prefiero | R], positivo, R) :- !.
detectar_marcador([amo | R], positivo, R) :- !.
detectar_marcador([no, me, gusta | R], negativo, R) :- !.
detectar_marcador([me, cuesta | R], negativo, R) :- !.
detectar_marcador([odio | R], negativo, R) :- !.
detectar_marcador([detesto | R], negativo, R) :- !.

separar_pares([], [], []).
separar_pares([(K, positivo) | R], [K | Pos], Neg) :- !,
    separar_pares(R, Pos, Neg).
separar_pares([(K, negativo) | R], Pos, [K | Neg]) :- !,
    separar_pares(R, Pos, Neg).

% -------------------------------------------------
% SINÓNIMOS
% -------------------------------------------------

sinonimo(tecnologia, tecnologia).
sinonimo(programacion, programacion).
sinonimo(computadoras, computadoras).
sinonimo(software, programacion).
sinonimo(salud, salud).
sinonimo(medicina, salud).
sinonimo(biologia, biologia).
sinonimo(ayudar, ayudar).
sinonimo(pacientes, personas).
sinonimo(leyes, derecho).
sinonimo(justicia, derecho).
sinonimo(abogado, derecho).
sinonimo(personas, personas).
sinonimo(mente, mente).
sinonimo(emociones, emociones).
sinonimo(comportamiento, comportamiento).
sinonimo(arte, arte).
sinonimo(disenio, disenio).
sinonimo(espacio, espacio).
sinonimo(construccion, construccion).
sinonimo(negocios, negocios).
sinonimo(empresas, empresas).
sinonimo(economia, economia).
sinonimo(finanzas, finanzas).
sinonimo(liderazgo, liderazgo).
sinonimo(fisica, fisica).
sinonimo(infraestructura, infraestructura).
sinonimo(estructuras, estructuras).
sinonimo(calculo, calculo).
sinonimo(creatividad, creatividad).
sinonimo(creativo, creatividad).
sinonimo(color, color).
sinonimo(ilustracion, ilustracion).
sinonimo(fotografia, fotografia).
sinonimo(naturaleza, naturaleza).
sinonimo(animales, animales).
sinonimo(plantas, plantas).
sinonimo(ecologia, ecologia).
sinonimo(enseniar, ensenar).
sinonimo(ninos, ninos).
sinonimo(jovenes, jovenes).
sinonimo(pedagogia, pedagogia).
sinonimo(circuitos, circuitos).
sinonimo(robotica, robotica).
sinonimo(automatizacion, automatizacion).
sinonimo(hardware, hardware).
sinonimo(medios, medios).
sinonimo(periodismo, periodismo).
sinonimo(escribir, escritura).
sinonimo(cine, cine).
sinonimo(analitico, analitico).
sinonimo(logico, logico).
sinonimo(preciso, preciso).
sinonimo(concentrado, concentrado).
sinonimo(memorioso, memorioso).
sinonimo(dedicado, dedicado).
sinonimo(empatico, empatico).
sinonimo(responsable, responsable).
sinonimo(argumentativo, argumentativo).
sinonimo(critico, critico).
sinonimo(persuasivo, persuasivo).
sinonimo(lector, lector).
sinonimo(organizado, organizado).
sinonimo(artistico, artistico).
sinonimo(espacial, espacial).
sinonimo(planificador, planificador).
sinonimo(lider, liderazgo).
sinonimo(negociador, negociador).
sinonimo(detallista, detallista).
sinonimo(curioso, curiosidad).
sinonimo(observador, observador).
sinonimo(metodico, metodico).
sinonimo(paciente, paciente).
sinonimo(comunicativo, comunicativo).
sinonimo(reflexivo, reflexivo).
sinonimo(imaginativo, imaginativo).