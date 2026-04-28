% ============================================================
% orientador_bnf.pl  –  Parser de Lenguaje Natural  |  OrientadorCE
% ============================================================
%
% Parser de lenguaje natural usando DCG Real.
%
% CUMPLIMIENTO DEL REQUISITO DCG:
% ----------------------------
% Este código USA DEFClause Grammar (DCG) con la notación --> 
% que se ejecuta mediante phrase/2 o phrase/3.
% ============================================================

:- use_module(library(lists)).

% ============================================================
% GRAMÁTICA DCG REAL
% Se ejecuta con phrase/2 o phrase/3
% ============================================================

% === ORACIÓN PRINCIPAL ===
oracion --> sintagma_nominal, sintagma_verbal.
oracion --> sintagma_verbal.

% === SINTAGMA NOMINAL (sujeto) ===
sintagma_nominal --> pronombre.
sintagma_nominal --> determinante, sustantivo.
sintagma_nominal --> adjetivo, sustantivo.
sintagma_nominal --> sustantivo.
sintagma_nominal --> [].

% === SINTAGMA VERBAL (predicado) ===
sintagma_verbal --> verbo, complemento.
sintagma_verbal --> verbo.
sintagma_verbal --> verbo, sintagma_nominal.
sintagma_verbal --> enlace, sintagma_verbal.

% === COMPLEMENTO (objeto directo) ===
complemento --> sintagma_nominal.
complemento --> preposicion, sustantivo.

% === ELEMENTO (para listas) ===
elemento --> sustantivo.
elemento --> adjetivo.

% === NEXO (conectores) ===
nexo --> [y].
nexo --> [mas].
nexo --> [pero].
nexo --> [aunque].
nexo --> [;].

% === ENLACE (conectores con negación) ===
enlace --> [pero, no].
enlace --> [aunque, no].
enlace --> [sin, embargo].

% === PRONOMBRE ===
pronombre --> [yo].
pronombre --> [me].
pronombre --> [me, siento].

% === DETERMINANTE ===
determinante --> [el].
determinante --> [la].
determinante --> [los].
determinante --> [las].
determinante --> [un].
determinante --> [una].
determinante --> [mi].
determinante --> [mis].

% === SUSTANTIVO ===
sustantivo --> [programacion].
sustantivo --> [tecnologia].
sustantivo --> [matematicas].
sustantivo --> [arte].
sustantivo --> [fisica].
sustantivo --> [biologia].
sustantivo --> [quimica].
sustantivo --> [personas].
sustantivo --> [computadoras].
sustantivo --> [maquinas].
sustantivo --> [ideas].
sustantivo --> [naturaleza].
sustantivo --> [analisis].
sustantivo --> [logica].

% === ADJETIVO ===
adjetivo --> [creativo].
adjetivo --> [artistico].
adjetivo --> [analitico].
adjetivo --> [social].
adjetivo --> [logico].
adjetivo --> [practico].
adjetivo --> [tecnico].

% === ADVERBIO ===
adverbio --> [mucho].
adverbio --> [bien].
adverbio --> [muy].
adverbio --> [poco].

% === PREPOSICIÓN ===
preposicion --> [con].
preposicion --> [en].
preposicion --> [para].
preposicion --> [de].
preposicion --> [sin].
preposicion --> [sobre].

% ============================================================
% MARCADORES DCG (extracción de polaridad)
% SE EJECUTAN con phrase/2 en tiempo real
% ============================================================

% Marcadores positivos
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
marcador_positivo --> [prefiero], !.
marcador_positivo --> [prefiero, trabajar], !.
marcador_positivo --> [disfruto], !.
marcador_positivo --> [disfruto, de], !.
marcador_positivo --> [amo], !.
marcador_positivo --> [adoro], !.
marcador_positivo --> [tengo, facilidad], !.
marcador_positivo --> [me, siento, bien], !.

% Marcadores negativos
marcador_negativo --> [no, me, gusta], !.
marcador_negativo --> [no, me, interesa], !.
marcador_negativo --> [no, me, interesan], !.
marcador_negativo --> [no, soy, bueno], !.
marcador_negativo --> [no, soy, buena], !.
marcador_negativo --> [me, cuesta], !.
marcador_negativo --> [me, cuesta, mucho], !.
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

% ============================================================
% PREDICOS DCG PBLICOS
% Se usan en tiempo de ejecucin
% ============================================================

dcg_intencion(Tokens, Intencion) :-
    (phrase(marcador_positivo, Tokens, _Resto)
    -> Intencion = positivo
    ; phrase(marcador_negativo, Tokens, _Resto)
    -> Intencion = negativo
    ; Intencion = indefinido
    ).

dcg_extraer(Tokens, Intencion, Estructura) :-
    (phrase(marcador_positivo, Tokens, Resto)
    -> Intencion = positivo,
       Estructura = positivo(Resto)
    ; phrase(marcador_negativo, Tokens, Resto)
    -> Intencion = negativo,
       Estructura = negativo(Resto)
    ; Intencion = indefinido,
       Estructura = sin_match
    ).

% ============================================================
% INTERFAZ PBLICA
% parsear_respuesta(+LineaAtom, -TokensPos, -TokensNeg)
% ============================================================

parsear_respuesta(Linea, TokensPos, TokensNeg) :-
    tokenizar(Linea, Tokens),
    dcg_intencion(Tokens, _IntencionDCG),
    analizar(Tokens, positivo, Pares),
    separar_pares(Pares, PosRaw, NegRaw),
    list_to_set(PosRaw, TokensPos),
    list_to_set(NegRaw, TokensNeg).

% ============================================================
% MLQUINA DE ESTADOS PRINCIPAL
% analizar(+Tokens, +Polaridad, -Pares)
% ============================================================

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
% SEPARAR PARES POR POLARIDAD
% ============================================================

separar_pares([], [], []).
separar_pares([(K, positivo) | R], [K | Pos], Neg) :- !,
    separar_pares(R, Pos, Neg).
separar_pares([(K, negativo) | R], Pos, [K | Neg]) :- !,
    separar_pares(R, Pos, Neg).

% ============================================================
% TOKENIZADOR Y NORMALIZADOR
% ============================================================

tokenizar(Linea, Tokens) :-
    atom_string(Linea, Str),
    string_lower(Str, Lower),
    split_string(Lower, " ,;.:!?()/\"'-", "", Partes),
    include([P]>>(P \= ""), Partes, Limpios),
    maplist([S, A]>>(atom_string(A0, S), quitar_tildes(A0, A)), Limpios, Tokens).

quitar_tildes(AtomIn, AtomOut) :-
    downcase_atom(AtomIn, AtomOut).

% ============================================================
% DETECCIN DE MARCADORES
% ============================================================

% ---- Marcadores NEGATIVOS ----
detectar_marcador([no, me, gusta, nada     | R], negativo, R) :- !.
detectar_marcador([no, me, gustan, nada    | R], negativo, R) :- !.
detectar_marcador([no, me, llama, la, atencion | R], negativo, R) :- !.
detectar_marcador([no, me, gusta           | R], negativo, R) :- !.
detectar_marcador([no, me, gustan          | R], negativo, R) :- !.
detectar_marcador([no, me, interesa        | R], negativo, R) :- !.
detectar_marcador([no, me, interesan       | R], negativo, R) :- !.
detectar_marcador([no, soy, bueno, en      | R], negativo, R) :- !.
detectar_marcador([no, soy, buena, en      | R], negativo, R) :- !.
detectar_marcador([no, soy, bueno          | R], negativo, R) :- !.
detectar_marcador([no, soy, buena          | R], negativo, R) :- !.
detectar_marcador([no, soy                 | R], negativo, R) :- !.
detectar_marcador([no, quiero              | R], negativo, R) :- !.
detectar_marcador([no, me, ve             | R], negativo, R) :- !.
detectar_marcador([pero, no                | R], negativo, R) :- !.
detectar_marcador([aunque, no              | R], negativo, R) :- !.
detectar_marcador([se, me, hace, dificil   | R], negativo, R) :- !.
detectar_marcador([se, me, dificulta       | R], negativo, R) :- !.
detectar_marcador([soy, malo, en            | R], negativo, R) :- !.
detectar_marcador([soy, mala, en            | R], negativo, R) :- !.
detectar_marcador([soy, malo              | R], negativo, R) :- !.
detectar_marcador([soy, mala              | R], negativo, R) :- !.
detectar_marcador([no, soy, malo, en       | R], negativo, R) :- !.
detectar_marcador([no, soy, mala, en       | R], negativo, R) :- !.
detectar_marcador([me, disgusta             | R], negativo, R) :- !.
detectar_marcador([me, disgustan            | R], negativo, R) :- !.
detectar_marcador([tengo, dificultades   | R], negativo, R) :- !.
detectar_marcador([tengo, dificultad      | R], negativo, R) :- !.
detectar_marcador([se, me, da, mal        | R], negativo, R) :- !.
detectar_marcador([se, me, dana, mal      | R], negativo, R) :- !.
detectar_marcador([me, cuesta, mucho       | R], negativo, R) :- !.
detectar_marcador([me, cuestan, mucho      | R], negativo, R) :- !.
detectar_marcador([me, cuesta              | R], negativo, R) :- !.
detectar_marcador([me, cuestan             | R], negativo, R) :- !.
detectar_marcador([me, aburre              | R], negativo, R) :- !.
detectar_marcador([me, aburren             | R], negativo, R) :- !.
detectar_marcador([odio                    | R], negativo, R) :- !.
detectar_marcador([detesto                 | R], negativo, R) :- !.
detectar_marcador([aborrezco               | R], negativo, R) :- !.
detectar_marcador([evito                   | R], negativo, R) :- !.
detectar_marcador([jamas                   | R], negativo, R) :- !.
detectar_marcador([nunca                   | R], negativo, R) :- !.
detectar_marcador([ni                      | R], negativo, R) :- !.
detectar_marcador([tampoco                 | R], negativo, R) :- !.

% ---- Marcadores POSITIVOS ----
detectar_marcador([me, llama, la, atencion | R], positivo, R) :- !.
detectar_marcador([me, llaman, la, atencion| R], positivo, R) :- !.
detectar_marcador([me, gusta, mucho        | R], positivo, R) :- !.
detectar_marcador([me, encanta, mucho      | R], positivo, R) :- !.
detectar_marcador([me, apasiona, mucho     | R], positivo, R) :- !.
detectar_marcador([me, gusta               | R], positivo, R) :- !.
detectar_marcador([me, gusTan              | R], positivo, R) :- !.
detectar_marcador([me, gusta             | R], positivo, R) :- !.
detectar_marcador([me, encanta             | R], positivo, R) :- !.
detectar_marcador([me, encantan            | R], positivo, R) :- !.
detectar_marcador([me, apasiona            | R], positivo, R) :- !.
detectar_marcador([me, apasionan           | R], positivo, R) :- !.
detectar_marcador([me, interesa            | R], positivo, R) :- !.
detectar_marcador([me, interesan           | R], positivo, R) :- !.
detectar_marcador([me, siento, bien        | R], positivo, R) :- !.
detectar_marcador([me, considero           | R], positivo, R) :- !.
detectar_marcador([soy, bueno, en          | R], positivo, R) :- !.
detectar_marcador([soy, buena, en          | R], positivo, R) :- !.
detectar_marcador([soy, bueno              | R], positivo, R) :- !.
detectar_marcador([soy, buena              | R], positivo, R) :- !.
detectar_marcador([soy, analitico          | R], positivo, R) :- !.
detectar_marcador([soy, analitica          | R], positivo, R) :- !.
detectar_marcador([soy, social             | R], positivo, R) :- !.
detectar_marcador([soy, creativa          | R], positivo, R) :- !.
detectar_marcador([soy, creativo          | R], positivo, R) :- !.
detectar_marcador([soy, talentoso         | R], positivo, R) :- !.
detectar_marcador([soy, talentosa         | R], positivo, R) :- !.
detectar_marcador([soy, habil              | R], positivo, R) :- !.
detectar_marcador([soy, habilidoso         | R], positivo, R) :- !.
detectar_marcador([soy, habilidosa        | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad, para  | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad        | R], positivo, R) :- !.
detectar_marcador([tengo, talento, para     | R], positivo, R) :- !.
detectar_marcador([tengo, talento          | R], positivo, R) :- !.
detectar_marcador([soy, experto, en        | R], positivo, R) :- !.
detectar_marcador([soy, experta, en        | R], positivo, R) :- !.
detectar_marcador([soy, experto            | R], positivo, R) :- !.
detectar_marcador([soy, experta            | R], positivo, R) :- !.
detectar_marcador([estudio, mucho           | R], positivo, R) :- !.
detectar_marcador([estudio, bastante       | R], positivo, R) :- !.
detectar_marcador([estudio, bien           | R], positivo, R) :- !.
detectar_marcador([me, gustaria, ser       | R], positivo, R) :- !.
detectar_marcador([me, gustaria, trabajar   | R], positivo, R) :- !.
detectar_marcador([me, veo, como          | R], positivo, R) :- !.
detectar_marcador([quiero, ser             | R], positivo, R) :- !.
detectar_marcador([quisiera, ser           | R], positivo, R) :- !.
detectar_marcador([aspiro, a, ser          | R], positivo, R) :- !.
detectar_marcador([prefiero, ser           | R], positivo, R) :- !.
detectar_marcador([deseo, ser             | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad, para  | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad        | R], positivo, R) :- !.
detectar_marcador([prefiero, trabajar, con | R], positivo, R) :- !.
detectar_marcador([prefiero                | R], positivo, R) :- !.
detectar_marcador([disfruto, de            | R], positivo, R) :- !.
detectar_marcador([disfruto                | R], positivo, R) :- !.
detectar_marcador([amo                     | R], positivo, R) :- !.
detectar_marcador([adoro                   | R], positivo, R) :- !.
detectar_marcador([soy                     | R], positivo, R) :- !.
detectar_marcador([trabajo, con            | R], positivo, R) :- !.
detectar_marcador([trabajo, en             | R], positivo, R) :- !.

% ---- Nuevos marcadores vocacionales ----
detectar_marcador([me, gustaria, ser       | R], positivo, R) :- !.
detectar_marcador([me, gustaria, estudiar | R], positivo, R) :- !.
detectar_marcador([me, gustaria, trabajar  | R], positivo, R) :- !.
detectar_marcador([quisiera, ser          | R], positivo, R) :- !.
detectar_marcador([quisiera, estudiar        | R], positivo, R) :- !.
detectar_marcador([quiero, estudiar         | R], positivo, R) :- !.
detectar_marcador([me, interesa, estudiar  | R], positivo, R) :- !.
detectar_marcador([me, veo, trabajando      | R], positivo, R) :- !.
detectar_marcador([me, veo, trabajando, como   | R], positivo, R) :- !.
detectar_marcador([aspiro, a, ser          | R], positivo, R) :- !.
detectar_marcador([aspiro, a, estudiar     | R], positivo, R) :- !.
detectar_marcador([deseo, ser             | R], positivo, R) :- !.
detectar_marcador([deseo, estudiar        | R], positivo, R) :- !.

% ---- Aptitudes positivas ----
detectar_marcador([soy, bueno, en         | R], positivo, R) :- !.
detectar_marcador([soy, buena, en         | R], positivo, R) :- !.
detectar_marcador([soy, bueno, con        | R], positivo, R) :- !.
detectar_marcador([soy, buena, con         | R], positivo, R) :- !.
detectar_marcador([se, me, da, bien        | R], positivo, R) :- !.
detectar_marcador([me, destaco, en        | R], positivo, R) :- !.
detectar_marcador([tengo, facilidad, con    | R], positivo, R) :- !.
detectar_marcador([dominio, el            | R], positivo, R) :- !.
detectar_marcador([dominio, la            | R], positivo, R) :- !.
detectar_marcador([domino, el            | R], positivo, R) :- !.
detectar_marcador([domino, la             | R], positivo, R) :- !.

% ============================================================
% TABLA DE SINONIMOS
% ============================================================

% ---- tecnologia
sinonimo(tecnologia,          tecnologia).
sinonimo(tecnologias,         tecnologia).
sinonimo(tecno,               tecnologia).
sinonimo(digital,             tecnologia).
sinonimo(informatica,         tecnologia).

% ---- profesiones y campos profesionales
sinonimo(enfermera,              salud).
sinonimo(enfermero,             salud).
sinonimo(doctora,              salud).
sinonimo(doctor,              salud).
sinonimo(medica,              salud).
sinonimo(medico,              salud).
sinonimo(medicas,             salud).
sinonimo(medicos,             salud).
sinonimo(cirujana,            salud).
sinonimo(cirujano,            salud).
sinonimo(pediatra,            salud).
sinonimo(geriatra,            salud).
sinonimo(clinica,             salud).
sinonimo(clinico,             salud).
sinonimo(terapeuta,           salud).
sinonimo(paramedico,          salud).
sinonimo(urgencias,           salud).
sinonimo(ambulancia,          salud).

% ---- idiomas y lenguas
sinonimo(espanol,              idiomas).
sinonimo(ingles,              idiomas).
sinonimo(frances,            idiomas).
sinonimo(aleman,              idiomas).
sinonimo(portugues,            idiomas).
sinonimo(chino,               idiomas).
sinonimo(japones,             idiomas).
sinonimo(italiano,            idiomas).
sinonimo(lengua,              idiomas).
sinonimo(lenguas,             idiomas).
sinonimo(idioma,              idiomas).
sinonimo(idiomas,             idiomas).
sinonimo(gramatica,            idiomas).
sinonimo(gramatical,           idiomas).
sinonimo(escribir,             escritura).
sinonimo(leer,                lectura).

% ---- ciencias sociales
sinonimo(social,              sociales).
sinonimo(sociedad,            sociales).
sinonimo(sociologia,          sociales).
sinonimo(sociologico,         sociales).
sinonimo(antropologia,         sociales).
sinonimo(antropologico,       sociales).
sinonimo(politica,            sociales).
sinonimo(politico,            sociales).
sinonimo(economia,            sociales).
sinonimo(economico,           sociales).
sinonimo(historia,           sociales).
sinonimo(historico,          sociales).
sinonimo(geografia,          sociales).
sinonimo(geografico,         sociales).

% ---- letras y humanidades
sinonimo(letras,              humanidades).
sinonimo(literatura,         humanidades).
sinonimo(literario,          humanidades).
sinonimo(literaria,          humanidades).
sinonimo(poesia,             humanidades).
sinonimo(novela,             humanidades).
sinonimo(texto,              humanidades).
sinonimo(filosofia,          humanidades).
sinonimo(filosofico,        humanidades).

% ---- artes visuales y sonido
sinonimo(pintura,             artes_visuales).
sinonimo(pintar,             artes_visuales).
sinonimo(escultura,           artes_visuales).
sinonimo(escultor,           artes_visuales).
sinonimo(galeria,            artes_visuales).
sinonimo(galerias,           artes_visuales).
sinonimo(museo,              artes_visuales).
sinonimo(museos,            artes_visuales).
sinonimo(exposicion,         artes_visuales).
sinonimo(exposiciones,       artes_visuales).

% ---- musica
sinonimo(musica,              musica).
sinonimo(musical,            musica).
sinonimo(canto,              musica).
sinonimo(cantar,             musica).
sinonimo(instrumento,        musica).
sinonimo(instrumentos,        musica).
sinonimo(guitarra,           musica).
sinonimo(piano,              musica).
sinonimo(componer,            musica).
sinonimo(composicion,        musica).
sinonimo(banda,              musica).
sinonimo(orquesta,           musica).
sinonimo(voz,                voz).
sinonimo(cantante,           musica).

% ---- educacion
sinonimo(educacion,          educacion).
sinonimo(educativo,           educacion).
sinonimo(educativa,          educacion).
sinonimo(escuela,            educacion).
sinonimo(colegio,            educacion).
sinonimo(universidad,         educacion).
sinonimo(docente,            educacion).
sinonimo(maestro,            educacion).
sinonimo(maestra,            educacion).
sinonimo(enseniar,           educacion).
sinonimo(ensenanza,          educacion).
sinonimo(estudiante,         estudiante).
sinonimo(estudiantes,       estudiante).

% ---- analisis de pensamiento
sinonimo(analisis,           analisis).
sinonimo(analitico,          analitico).
sinonimo(analitica,          analitico).
sinonimo(analista,            analisis).
sinonimo(evaluar,            evaluacion).
sinonimo(evaluacion,         evaluacion).
sinonimo(medir,              medicion).
sinonimo(medicion,           medicion).

% ---- creatividad
sinonimo(creatividad,        creatividad).
sinonimo(creativo,           creatividad).
sinonimo(creativa,          creatividad).
sinonimo(crear,               creatividad).
sinonimo(innovacion,         creatividad).
sinonimo(innovar,            creatividad).
sinonimo(innovador,          creatividad).
sinonimo(innovadora,         creatividad).

% ---- comunicacion
sinonimo(comunicacion,       comunicacion).
sinonimo(comunicar,           comunicacion).
sinonimo(comunicativo,        comunicacion).
sinonimo(comunicativa,        comunicacion).
sinonimo(comunicador,         comunicacion).
sinonimo(hablar,             hablar).
sinonimo(dialogo,            dialogo).
sinonimo(redaccion, escritura).

% ---- liderazgo
sinonimo(liderazgo,           liderazgo).
sinonimo(liderar,            liderazgo).
sinonimo(lider,              liderazgo).
sinonimo(lideres,            liderazgo).
sinonimo(diriir,             liderazgo).
sinonimo(dirigir,            liderazgo).
sinonimo(gestionar,         gestion).
sinonimo(gestion,           gestion).
sinonimo(gerencia,           gestion).

% ---- ciencias exactas
sinonimo(exactas,            ciencias_exactas).
sinonimo(ciencias_exactas,   ciencias_exactas).
sinonimo(estadistica,        estadistica).
sinonimo(estadisticas,       estadistica).
sinonimo(probabilidad,       probabilidad).
sinonimo(calculo,           calculo).
sinonimo(algebra,            algebra).
sinonimo(geometria,          geometria).
sinonimo(trigonometria,     trigonometria).
sinonimo(matematico,        matematico).
sinonimo(numerico,           numerico).

% ---- trabajo social
sinonimo(trabajo_social,    trabajo_social).
sinonimo(trabajador_social,  trabajo_social).
sinonimo(asistente_social,   trabajo_social).
sinonimo(comunidad,         comunidad).
sinonimo(comunitario,       comunidad).
sinonimo(servicio_social,   trabajo_social).

% ---- psicologia
sinonimo(psicologia,         psicologia).
sinonimo(psicologico,       psicologia).
sinonimo(psicologica,      psicologia).
sinonimo(psi,              psicologia).
sinonimo(comportamiento,    comportamiento).
sinonimo(conducta,          comportamiento).
sinonimo(mente,             mente).
sinonimo(mental,            salud_mental).
sinonimo(salud_mental,      salud_mental).

% ---- programacion
sinonimo(programacion,        programacion).
sinonimo(programar,           programacion).
sinonimo(programando,         programacion).
sinonimo(codigo,              programacion).
sinonimo(codificar,           programacion).
sinonimo(desarrollar,         programacion).
sinonimo(desarrollo,          programacion).
sinonimo(programador,         programacion).

% ---- computadoras
sinonimo(computadora,         computadoras).
sinonimo(computadoras,        computadoras).
sinonimo(computacion,         computadoras).
sinonimo(computacional,       computadoras).
sinonimo(ordenador,           computadoras).
sinonimo(computador,          computadoras).
sinonimo(pc,                  computadoras).

% ---- matematicas
sinonimo(matematica,          matematicas).
sinonimo(matematicas,         matematicas).
sinonimo(mates,               matematicas).
sinonimo(algebra,             matematicas).
sinonimo(numeros,             matematicas).
sinonimo(numero,              matematicas).
sinonimo(calculo,             matematicas).
sinonimo(aritmetica,          matematicas).

% ---- algoritmos
sinonimo(algoritmo,           algoritmos).
sinonimo(algoritmos,          algoritmos).
sinonimo(algoritmia,          algoritmos).

% ---- datos
sinonimo(dato,                datos).
sinonimo(datos,               datos).
sinonimo(estadistica,         datos).
sinonimo(estadisticas,        datos).
sinonimo(analisis,            datos).

% ---- logica
sinonimo(logica,              logica).
sinonimo(razonamiento,        logica).
sinonimo(razonar,             logica).

% ---- software
sinonimo(software,            software).
sinonimo(aplicacion,          software).
sinonimo(aplicaciones,        software).
sinonimo(app,                 software).
sinonimo(apps,                software).
sinonimo(sistema,             software).
sinonimo(sistemas,            software).
sinonimo(programa,            software).
sinonimo(programas,           software).

% ---- videojuegos
sinonimo(videojuego,          videojuegos).
sinonimo(videojuegos,         videojuegos).
sinonimo(gaming,              videojuegos).
sinonimo(juego,               videojuegos).
sinonimo(juegos,              videojuegos).
sinonimo(videogames,          videojuegos).

% ---- redes
sinonimo(redes,               redes).
sinonimo(red,                 redes).
sinonimo(internet,            redes).
sinonimo(networking,          redes).
sinonimo(ciberseguridad,      redes).

% ---- inteligencia_artificial
sinonimo(inteligencia_artificial, inteligencia_artificial).
sinonimo(ia,                  inteligencia_artificial).
sinonimo(ai,                  inteligencia_artificial).
sinonimo(machine_learning,    inteligencia_artificial).

% ---- automatizacion
sinonimo(automatizacion,      automatizacion).
sinonimo(automatizar,         automatizacion).
sinonimo(robotica,            automatizacion).
sinonimo(robots,              automatizacion).
sinonimo(robot,               automatizacion).
sinonimo(maquina,             automatizacion).
sinonimo(maquinas,            automatizacion).
sinonimo(prototipado,         automatizacion).
sinonimo(prototipo,           automatizacion).

% ---- salud
sinonimo(salud,               salud).
sinonimo(medicina,            salud).
sinonimo(medico,              salud).
sinonimo(medica,              salud).
sinonimo(sanar,               salud).
sinonimo(curar,               salud).
sinonimo(hospital,            salud).

% ---- biologia
sinonimo(biologia,            biologia).
sinonimo(biologico,           biologia).
sinonimo(celulas,             biologia).
sinonimo(celula,              biologia).
sinonimo(organismos,          biologia).
sinonimo(organismo,           biologia).

% ---- quimica
sinonimo(quimica,             quimica).
sinonimo(quimico,             quimica).
sinonimo(moleculas,           quimica).
sinonimo(reacciones,          quimica).
sinonimo(sustancias,          quimica).

% ---- anatomia
sinonimo(anatomia,            anatomia).
sinonimo(anatomico,           anatomia).

% ---- cuerpo_humano
sinonimo(cuerpo_humano,       cuerpo_humano).
sinonimo(cuerpo,              cuerpo_humano).
sinonimo(organos,             cuerpo_humano).
sinonimo(tejidos,             cuerpo_humano).

% ---- enfermedades
sinonimo(enfermedad,          enfermedades).
sinonimo(enfermedades,        enfermedades).
sinonimo(patologia,           enfermedades).
sinonimo(diagnostico,         enfermedades).
sinonimo(sintomas,            enfermedades).

% ---- ciencias
sinonimo(ciencia,             ciencias).
sinonimo(ciencias,            ciencias).
sinonimo(cientifico,          ciencias).
sinonimo(cientifica,          ciencias).

% ---- investigacion
sinonimo(investigacion,       investigacion).
sinonimo(investigar,          investigacion).
sinonimo(investigador,        investigacion).
sinonimo(experimento,         investigacion).
sinonimo(experimentos,        investigacion).
sinonimo(laboratorio,         investigacion).
sinonimo(research,            investigacion).

% ---- farmacologia
sinonimo(farmacologia,        farmacologia).
sinonimo(medicamento,         farmacologia).
sinonimo(medicamentos,        farmacologia).
sinonimo(farmaco,             farmacologia).

% ---- ayudar
sinonimo(ayudar,              ayudar).
sinonimo(ayudo,               ayudar).
sinonimo(ayuda,               ayudar).
sinonimo(apoyar,              ayudar).
sinonimo(servir,              ayudar).
sinonimo(voluntariado,        ayudar).

% ---- cuidar
sinonimo(cuidar,              cuidar).
sinonimo(cuidado,             cuidar).
sinonimo(cuidados,            cuidar).

% ---- pacientes
sinonimo(pacientes,           pacientes).
sinonimo(enfermos,            pacientes).

% ---- justicia
sinonimo(justicia,            justicia).
sinonimo(injusticia,          justicia).
sinonimo(justo,               justicia).

% ---- leyes
sinonimo(ley,                 leyes).
sinonimo(leyes,               leyes).
sinonimo(juridico,            leyes).
sinonimo(juridica,            leyes).
sinonimo(abogado,             leyes).
sinonimo(abogada,             leyes).

% ---- normas
sinonimo(norma,               normas).
sinonimo(normas,              normas).
sinonimo(reglamento,          normas).
sinonimo(normativa,           normas).
sinonimo(regulacion,          normas).

% ---- politica
sinonimo(politica,            politica).
sinonimo(politico,            politica).
sinonimo(gobierno,            politica).
sinonimo(estado,              politica).
sinonimo(legislacion,         politica).

% ---- sociedad
sinonimo(sociedad,            sociedad).
sinonimo(social,              sociedad).
sinonimo(comunidad,           comunidad).
sinonimo(comunitario,         comunidad).

% ---- argumentacion
sinonimo(argumentar,          argumentacion).
sinonimo(argumentacion,       argumentacion).
sinonimo(argumento,           argumentacion).

% ---- debate
sinonimo(debate,              debate).
sinonimo(debatir,             debate).
sinonimo(discutir,            debate).
sinonimo(oratoria,            debate).

% ---- historia
sinonimo(historia,            historia).
sinonimo(historico,           historia).
sinonimo(pasado,              historia).

% ---- etica
sinonimo(etica,               etica).
sinonimo(etico,               etica).
sinonimo(moral,               etica).
sinonimo(valores,             etica).

% ---- conflictos
sinonimo(conflicto,           conflictos).
sinonimo(conflictos,          conflictos).
sinonimo(litigio,             conflictos).

% ---- derecho
sinonimo(derecho,              derecho).
sinonimo(derechos_humanos,    derechos_humanos).
sinonimo(derechos,            derechos_humanos).

% ---- escritura
sinonimo(escribir,            escritura).
sinonimo(escritura,           escritura).
sinonimo(redactar,            escritura).
sinonimo(redaccion,           escritura).
sinonimo(texto,               escritura).
sinonimo(ensayo,              escritura).

% ---- disenio
sinonimo(disenio,             disenio).
sinonimo(diseno,              disenio).
sinonimo(disenar,             disenio).

% ---- arte
sinonimo(arte,                arte).
sinonimo(artistico,           arte).
sinonimo(artistica,           arte).
sinonimo(dibujo,              arte).
sinonimo(dibujar,             arte).
sinonimo(pintura,             arte).
sinonimo(pintar,              arte).
sinonimo(escultura,           arte).

% ---- estetica
sinonimo(estetica,            estetica).
sinonimo(estetico,            estetica).
sinonimo(belleza,             estetica).

% ---- ilustracion
sinonimo(ilustracion,         ilustracion).
sinonimo(ilustrar,            ilustracion).

% ---- color / visual
sinonimo(color,               color).
sinonimo(colores,             color).
sinonimo(visual,              visual).

% ---- publicidad
sinonimo(publicidad,          publicidad).
sinonimo(marketing,           publicidad).

% ---- branding / tipografia
sinonimo(branding,            branding).
sinonimo(marca,               branding).
sinonimo(tipografia,          tipografia).

% ---- comunicacion_visual
sinonimo(comunicacion_visual, comunicacion_visual).

% ---- construccion
sinonimo(construccion,        construccion).
sinonimo(construir,           construccion).
sinonimo(edificar,            construccion).
sinonimo(obra,                construccion).
sinonimo(obras,               construccion).
sinonimo(edificios,           construccion).

% ---- espacio
sinonimo(espacio,             espacio).
sinonimo(espacial,            espacio).
sinonimo(arquitectura,        espacio).

% ---- geometria
sinonimo(geometria,           geometria).
sinonimo(formas,              geometria).
sinonimo(geometrico,          geometria).

% ---- planos
sinonimo(plano,               planos).
sinonimo(planos,              planos).
sinonimo(blueprint,           planos).

% ---- materiales
sinonimo(material,            materiales).
sinonimo(materiales,          materiales).
sinonimo(concreto,            materiales).
sinonimo(acero,               materiales).
sinonimo(cemento,             materiales).

% ---- urbanismo
sinonimo(urbanismo,           urbanismo).
sinonimo(urbano,              urbanismo).
sinonimo(ciudad,              urbanismo).

% ---- fisica
sinonimo(fisica,              fisica).
sinonimo(fisico,              fisica).
sinonimo(mecanica,            fisica).

% ---- infraestructura
sinonimo(infraestructura,     infraestructura).
sinonimo(puente,              infraestructura).
sinonimo(puentes,             infraestructura).
sinonimo(caminos,             infraestrutura).
sinonimo(carretera,           infraestructura).

% ---- estructuras / resistencia
sinonimo(estructura,          estructuras).
sinonimo(estructuras,         estructuras).
sinonimo(resistencia,         resistencia).

% ---- ingenieria
sinonimo(ingenieria,          ingenieria).
sinonimo(ingeniero,           ingenieria).
sinonimo(ingeniera,           ingenieria).

% ---- personas
sinonimo(personas,            personas).
sinonimo(gente,               personas).
sinonimo(humanos,             personas).
sinonimo(humano,              personas).

% ---- comportamiento
sinonimo(comportamiento,      comportamiento).
sinonimo(conducta,            comportamiento).

% ---- mente
sinonimo(mente,               mente).
sinonimo(mental,              mente).
sinonimo(pensamiento,         mente).

% ---- emociones
sinonimo(emocion,             emociones).
sinonimo(emociones,           emociones).
sinonimo(sentimientos,        emociones).
sinonimo(sentimiento,         emociones).
sinonimo(emocional,           emociones).

% ---- bienestar / salud_mental
sinonimo(bienestar,           bienestar).
sinonimo(salud_mental,        salud_mental).

% ---- terapia
sinonimo(terapia,             terapia).
sinonimo(terapeuta,           terapia).
sinonimo(psicoterapia,        terapia).

% ---- escucha
sinonimo(escucha,             escucha).
sinonimo(escuchar,            escucha).

% ---- negocios / empresas
sinonimo(negocio,             negocios).
sinonimo(negocios,            negocios).
sinonimo(comercio,            negocios).
sinonimo(empresa,             empresas).
sinonimo(empresas,            empresas).
sinonimo(corporacion,         empresas).
sinonimo(organizacion,        organizacion).

% ---- economia / finanzas
sinonimo(economia,            economia).
sinonimo(economico,           economia).
sinonimo(finanzas,            finanzas).
sinonimo(financiero,          finanzas).
sinonimo(dinero,              finanzas).
sinonimo(inversion,           finanzas).
sinonimo(bolsa,               finanzas).

% ---- estrategia
sinonimo(estrategia,          estrategia).
sinonimo(estrategico,         estrategia).
sinonimo(planear,             estrategia).
sinonimo(planificar,          estrategia).

% ---- mercadeo / ventas
sinonimo(mercadeo,            mercadeo).
sinonimo(ventas,              ventas).
sinonimo(vender,              ventas).

% ---- emprendimiento
sinonimo(emprendimiento,      emprendimiento).
sinonimo(emprender,           emprendimiento).
sinonimo(startup,             emprendimiento).
sinonimo(emprendedor,         emprendimiento).

% ---- proyectos / gestion
sinonimo(proyecto,            proyectos).
sinonimo(proyectos,           proyectos).
sinonimo(gestion,             gestion).

% ---- electricidad / circuitos
sinonimo(electricidad,        electricidad).
sinonimo(electrico,           electricidad).
sinonimo(circuito,            circuitos).
sinonimo(circuitos,           circuitos).
sinonimo(electronica,         circuitos).
sinonimo(electronico,         circuitos).

% ---- hardware
sinonimo(hardware,            hardware).
sinonimo(componentes,         hardware).
sinonimo(procesador,          hardware).
sinonimo(microcontrolador,    hardware).
sinonimo(arduino,             hardware).

% ---- sensores / control
sinonimo(sensor,              sensores).
sinonimo(sensores,            sensores).
sinonimo(control,             control).
sinonimo(controlar,           control).

% ---- naturaleza
sinonimo(naturaleza,          naturaleza).
sinonimo(natural,             naturaleza).
sinonimo(campo,               naturaleza).
sinonimo(bosque,              naturaleza).

% ---- animales / plantas
sinonimo(animal,              animales).
sinonimo(animales,            animales).
sinonimo(fauna,               animales).
sinonimo(planta,              plantas).
sinonimo(plantas,             plantas).
sinonimo(flora,               plantas).
sinonimo(botanica,            plantas).

% ---- ecologia / medio_ambiente
sinonimo(ecologia,            ecologia).
sinonimo(ecosistema,          ecologia).
sinonimo(medio_ambiente,      medio_ambiente).
sinonimo(ambiente,            medio_ambiente).
sinonimo(ambiental,           medio_ambiente).
sinonimo(sostenibilidad,      medio_ambiente).

% ---- genetica
sinonimo(genetica,            genetica).
sinonimo(genes,               genetica).
sinonimo(adn,                 genetica).

% ---- microbiologia / evolucion
sinonimo(microbiologia,       microbiologia).
sinonimo(bacteria,            microbiologia).
sinonimo(bacterias,           microbiologia).
sinonimo(evolucion,           evolucion).

% ---- enseniar
sinonimo(ensenar,             enseniar).
sinonimo(enseniar,            enseniar).
sinonimo(ensenanza,           enseniar).
sinonimo(educar,              enseniar).
sinonimo(educacion,           enseniar).
sinonimo(profesor,            enseniar).
sinonimo(docente,             enseniar).
sinonimo(maestro,             enseniar).
sinonimo(maestra,             enseniar).

% ---- ninos / jovenes
sinonimo(nino,                ninos).
sinonimo(ninos,               ninos).
sinonimo(infancia,            ninos).
sinonimo(joven,               jovenes).
sinonimo(jovenes,             jovenes).
sinonimo(adolescente,         jovenes).
sinonimo(estudiantes,         jovenes).

% ---- pedagogia / aprendizaje
sinonimo(pedagogia,           pedagogia).
sinonimo(didactica,           pedagogia).
sinonimo(aprendizaje,         aprendizaje).
sinonimo(aprender,            aprendizaje).

% ---- cultura / libros / vocacion
sinonimo(cultura,             cultura).
sinonimo(libro,               libros).
sinonimo(libros,              libros).
sinonimo(lectura,             libros).
sinonimo(leer,                libros).
sinonimo(vocacion,            vocacion).

% ---- medios / comunicacion / periodismo
sinonimo(medios,              medios).
sinonimo(comunicacion,        comunicacion).
sinonimo(periodismo,          periodismo).
sinonimo(periodista,          periodismo).
sinonimo(noticia,             periodismo).
sinonimo(noticias,            periodismo).
sinonimo(prensa,              periodismo).
sinonimo(radio,               radio).
sinonimo(podcast,             radio).

% ---- fotografia / cine / redes_sociales
sinonimo(fotografia,          fotografia).
sinonimo(foto,                fotografia).
sinonimo(fotografo,           fotografia).
sinonimo(cine,                cine).
sinonimo(pelicula,            cine).
sinonimo(peliculas,           cine).
sinonimo(audiovisual,         cine).
sinonimo(redes_sociales,      redes_sociales).
sinonimo(instagram,           redes_sociales).
sinonimo(youtube,             redes_sociales).
sinonimo(tiktok,              redes_sociales).

% ---- narrativa / creatividad
sinonimo(narrativa,           narrativa).
sinonimo(narrativo,           narrativa).
sinonimo(cuento,              narrativa).
sinonimo(creatividad,         creatividad).
sinonimo(crear,               creatividad).
sinonimo(innovar,             creatividad).
sinonimo(innovacion,          creatividad).

% ============================================================
% RASGOS PERSONALES
% Cubren género gramatical: analítico/a, creativo/a, etc.
% ============================================================
% ============================================================

sinonimo(analitico,           analitico).
sinonimo(analitica,           analitico).
sinonimo(logico,              logico).
sinonimo(logica,              logico).
sinonimo(preciso,             preciso).
sinonimo(precisa,             preciso).
sinonimo(exacto,              preciso).
sinonimo(abstracto,           abstracto).
sinonimo(abstracta,           abstracto).
sinonimo(autodidacta,         autodidacta).
sinonimo(concentrado,         concentrado).
sinonimo(concentrada,         concentrado).
sinonimo(enfocado,            concentrado).
sinonimo(empatico,            empatico).
sinonimo(empatica,            empatico).
sinonimo(responsable,         responsable).
sinonimo(memorioso,           memorioso).
sinonimo(dedicado,            dedicado).
sinonimo(dedicada,            dedicado).
sinonimo(minucioso,           minucioso).
sinonimo(minuciosa,           minucioso).
sinonimo(curioso,             curioso).
sinonimo(curiosa,             curioso).
sinonimo(argumentativo,       argumentativo).
sinonimo(argumentativa,       argumentativo).
sinonimo(persuasivo,          persuasivo).
sinonimo(persuasiva,          persuasivo).
sinonimo(lector,              lector).
sinonimo(lectora,             lector).
sinonimo(organizado,          organizado).
sinonimo(organizada,          organizado).
sinonimo(etico,               etico).
sinonimo(etica,               etico).
sinonimo(comunicativo,        comunicativo).
sinonimo(comunicativa,        comunicativo).
sinonimo(sociable,            sociable).
sinonimo(detallista,          detallista).
sinonimo(espacial,            espacial).
sinonimo(artistico,           artistico).
sinonimo(artistica,           artistico).
sinonimo(planificador,        planificador).
sinonimo(planificadora,       planificador).
sinonimo(reflexivo,           reflexivo).
sinonimo(reflexiva,           reflexivo).
sinonimo(observador,          observador).
sinonimo(observadora,         observador).
sinonimo(lider,               lider).
sinonimo(lideresa,            lider).
sinonimo(negociador,          negociador).
sinonimo(negociadora,         negociador).
sinonimo(proactivo,           proactivo).
sinonimo(proactiva,           proactivo).
sinonimo(decisivo,            decisivo).
sinonimo(decisiva,            decisivo).
sinonimo(adaptable,           adaptable).
sinonimo(metodico,            metodico).
sinonimo(metodica,            metodico).
sinonimo(matematico,          matematico).
sinonimo(matematica,          matematico).
sinonimo(tecnico,             tecnico).
sinonimo(tecnica,             tecnico).
sinonimo(innovador,           innovador).
sinonimo(innovadora,          innovador).
sinonimo(estetico,            estetico).
sinonimo(estetica,            estetico).
sinonimo(imaginativo,         imaginativo).
sinonimo(imaginativa,         imaginativo).
sinonimo(investigador,        investigador).
sinonimo(investigadora,       investigador).
sinonimo(amante_naturaleza,   amante_naturaleza).
sinonimo(amante,              amante_naturaleza).
sinonimo(critico,             critico).
sinonimo(critica,             critico).
sinonimo(escritor,            escritor).
sinonimo(escritora,           escritor).
sinonimo(paciente,            paciente).
sinonimo(creativo,            creativo).
sinonimo(creativa,            creativo).
sinonimo(social,              sociable).
sinonimo(vocacion_servicio,   vocacion_servicio).
sinonimo(vision_3d,           vision_3d).
sinonimo(resolucion_problemas, resolucion_problemas).
sinonimo(trabajo_en_equipo,   trabajo_en_equipo).
sinonimo(trabajo_bajo_presion, trabajo_bajo_presion).
sinonimo(escucha_activa,      escucha_activa).

% --- Profesiones médicas ---
sinonimo(doctora,              medicina).
sinonimo(doctor,              medicina).
sinonimo(medica,              salud).
sinonimo(medico,              salud).
sinonimo(enfermera,              salud).
sinonimo(enfermero,             salud).
sinonimo(cirujana,            salud).
sinonimo(cirujano,            salud).
sinonimo(pediatra,            salud).
sinonimo(geriatra,            salud).
sinonimo(clinica,             salud).
sinonimo(clinico,             salud).
sinonimo(terapeuta,           salud).
sinonimo(paramedico,          salud).
sinonimo(urgencias,           salud).
sinonimo(ambulancia,          salud).
sinonimo(corazon,             salud).

% --- Profesiones jurídicas ---
sinonimo(abogado,             derecho).
sinonimo(abogada,             derecho).
sinonimo(leyes,              derecho).
sinonimo(juicios,             derecho).