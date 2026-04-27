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
complemento --> lista_elementos.

lista_elementos --> elemento.
lista_elementos --> elemento, [y], lista_elementos.
lista_elementos --> elemento, [mas], lista_elementos.

elemento --> sustantivo.
elemento --> adjetivo.

sustantivo --> [programacion].
sustantivo --> [tecnologia].
sustantivo --> [matematicas].
sustantivo --> [arte].
sustantivo --> [fisica].
sustantivo --> [biologia].
sustantivo --> [quimica].
sustantivo --> [personas].
sustantivo --> [computadoras].
sustantivo --> [ideas].
sustantivo --> [naturaleza].
sustantivo --> [analisis].
sustantivo --> [logica].
sustantivo --> [espanol].
sustantivo --> [ingles].

pronombre --> [yo].
pronombre --> [me].

determinante --> [el].
determinante --> [la].
determinante --> [los].
determinante --> [las].
determinante --> [un].
determinante --> [una].

adjetivo --> [creativo].
adjetivo --> [artistico].
adjetivo --> [analitico].
adjetivo --> [analitica].
adjetivo --> [social].
adjetivo --> [logico].
adjetivo --> [logica].

verbo --> [gusta].
verbo --> [gustan].
verbo --> [encanta].
verbo --> [encantan].
verbo --> [apasiona].
verbo --> [apasionan].
verbo --> [interesa].
verbo --> [interesan].
verbo --> [prefiero].
verbo --> [cuesta].
verbo --> [aburre].

preposicion --> [con].
preposicion --> [en].
preposicion --> [para].
preposicion --> [de].

nexo --> [y].
nexo --> [mas].
nexo --> [pero].

enlace --> [pero, no].
enlace --> [aunque, no].
enlace --> [sin, embargo].

% ============================================================
% MARCADORES DCG
% ============================================================

marcador_positivo --> [me, gusta], !.
marcador_positivo --> [me, gusta, mucho], !.
marcador_positivo --> [me, gusta, bien], !.
marcador_positivo --> [me, encanta], !.
marcador_positivo --> [me, encanta, mucho], !.
marcador_positivo --> [me, apasiona], !.
marcador_positivo --> [me, apasiona, mucho], !.
marcador_positivo --> [me, interesa], !.
marcador_positivo --> [me, interesan], !.
marcador_positivo --> [me, llama, la, atencion], !.
marcador_positivo --> [soy], !.
marcador_positivo --> [soy, bueno], !.
marcador_positivo --> [soy, buena], !.
marcador_positivo --> [soy, bueno, en], !.
marcador_positivo --> [soy, buena, en], !.
marcador_positivo --> [soy, analitico], !.
marcador_positivo --> [soy, analitica], !.
marcador_positivo --> [soy, social], !.
marcador_positivo --> [soy, creativa], !.
marcador_positivo --> [soy, creativo], !.
marcador_positivo --> [prefiero], !.
marcador_positivo --> [prefiero, trabajar], !.
marcador_positivo --> [disfruto], !.
marcador_positivo --> [disfruto, de], !.
marcador_positivo --> [amo], !.
marcador_positivo --> [adoro], !.
marcador_positivo --> [tengo, facilidad], !.
marcador_positivo --> [tengo, facilidad, para], !.
marcador_positivo --> [me, siento, bien], !.

marcador_negativo --> [no, me, gusta], !.
marcador_negativo --> [no, me, interesa], !.
marcador_negativo --> [no, me, interesan], !.
marcador_negativo --> [no, soy, bueno], !.
marcador_negativo --> [no, soy, buena], !.
marcador_negativo --> [me, cuesta], !.
marcador_negativo --> [me, cuesta, mucho], !.
marcador_negativo --> [me, cuestan], !.
marcador_negativo --> [me, aburre], !.
marcador_negativo --> [me, aburren], !.
marcador_negativo --> [odio], !.
marcador_negativo --> [detesto], !.
marcador_negativo --> [aborrezco], !.
marcador_negativo --> [evito], !.
marcador_negativo --> [nunca], !.
marcador_negativo --> [jamas], !.
marcador_negativo --> [ni], !.
marcador_negativo --> [tampoco], !.
marcador_negativo --> [pero, no], !.
marcador_negativo --> [aunque, no], !.
marcador_negativo --> [soy, malo], !.
marcador_negativo --> [soy, mala], !.
marcador_negativo --> [soy, malo, en], !.
marcador_negativo --> [soy, mala, en], !.

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
    atom_concat(W1, '_', Tmp),
    atom_concat(Tmp, W2, Bigrama),
    sinonimo(Bigrama, K), !,
    analizar(Resto, Pol, Pares).
analizar([W | Resto], Pol, [(K, Pol) | Pares]) :-
    sinonimo(W, K), !,
    analizar(Resto, Pol, Pares).
analizar([_ | Resto], Pol, Pares) :-
    analizar(Resto, Pol, Pares).

% ============================================================
% DETECCIÓN DE MARCADORES
% ============================================================

detectar_marcador([me, gusta | R], positivo, R) :- !.
detectar_marcador([me, gusta, mucho | R], positivo, R) :- !.
detectar_marcador([me, gusta, bien | R], positivo, R) :- !.
detectar_marcador([me, encanta | R], positivo, R) :- !.
detectar_marcador([me, encanta, mucho | R], positivo, R) :- !.
detectar_marcador([me, apasiona | R], positivo, R) :- !.
detectar_marcador([me, apasiona, mucho | R], positivo, R) :- !.
detectar_marcador([me, interesa | R], positivo, R) :- !.
detectar_marcador([me, interesan | R], positivo, R) :- !.
detectar_marcador([me, llama, la, atencion | R], positivo, R) :- !.
detectar_marcador([soy | R], positivo, R) :- !.
detectar_marcador([soy, bueno | R], positivo, R) :- !.
detectar_marcador([soy, buena | R], positivo, R) :- !.
detectar_marcador([soy, bueno, en | R], positivo, R) :- !.
detectar_marcador([soy, buena, en | R], positivo, R) :- !.
detectar_marcador([soy, analitico | R], positivo, R) :- !.
detectar_marcador([soy, analitica | R], positivo, R) :- !.
detectar_marcador([soy, social | R], positivo, R) :- !.
detectar_marcador([soy, creativa | R], positivo, R) :- !.
detectar_marcador([soy, creativo | R], positivo, R) :- !.
detectar_marcador([prefiero | R], positivo, R) :- !.
detectar_marcador([prefiero, trabajar | R], positivo, R) :- !.
detectar_marcador([disfruto | R], positivo, R) :- !.
detectar_marcador([disfruto, de | R], positivo, R) :- !.
detectar_marcador([amo | R], positivo, R) :- !.
detectar_marcador([adoro | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad, para | R], positivo, R) :- !.
detectar_marcador([me, siento, bien | R], positivo, R) :- !.

detectar_marcador([no, me, gusta | R], negativo, R) :- !.
detectar_marcador([no, me, interesa | R], negativo, R) :- !.
detectar_marcador([no, me, interesan | R], negativo, R) :- !.
detectar_marcador([no, soy, bueno | R], negativo, R) :- !.
detectar_marcador([no, soy, buena | R], negativo, R) :- !.
detectar_marcador([me, cuesta | R], negativo, R) :- !.
detectar_marcador([me, cuesta, mucho | R], negativo, R) :- !.
detectar_marcador([me, cuestan | R], negativo, R) :- !.
detectar_marcador([me, aburre | R], negativo, R) :- !.
detectar_marcador([me, aburren | R], negativo, R) :- !.
detectar_marcador([odio | R], negativo, R) :- !.
detectar_marcador([detesto | R], negativo, R) :- !.
detectar_marcador([aborrezco | R], negativo, R) :- !.
detectar_marcador([evito | R], negativo, R) :- !.
detectar_marcador([nunca | R], negativo, R) :- !.
detectar_marcador([jamas | R], negativo, R) :- !.
detectar_marcador([ni | R], negativo, R) :- !.
detectar_marcador([tampoco | R], negativo, R) :- !.
detectar_marcador([pero, no | R], negativo, R) :- !.
detectar_marcador([aunque, no | R], negativo, R) :- !.
detectar_marcador([soy, malo | R], negativo, R) :- !.
detectar_marcador([soy, mala | R], negativo, R) :- !.
detectar_marcador([soy, malo, en | R], negativo, R) :- !.
detectar_marcador([soy, mala, en | R], negativo, R) :- !.

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
sinonimo(espanol, idiomas).
sinonimo(ingles, idiomas).
sinonimo(musica, musica).
sinonimo(matematicas, matematicas).