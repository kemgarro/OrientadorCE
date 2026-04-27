% ============================================================
% orientador_main.pl  –  Integrador  |  OrientadorCE
% ============================================================
%
% Punto de entrada del sistema experto.
% Requiere los módulos: orientador_bd.pl, orientador_bnf.pl, orientador_logic.pl
%
% USO:
%   $ swipl orientador_main.pl
%   ?- iniciar.
%
% ============================================================

:- use_module('orientador_bd.pl').
:- use_module('orientador_bnf.pl').
:- use_module('orientador_logic.pl').

:- initialization(main, main).

main :-
    mostrar_bienvenida,
    findall(N-T, pregunta(N, T), Pares),
    msort(Pares, Preguntas),
    length(Preguntas, Total),
    recopilar_respuestas(Preguntas, 1, Total, [], [], TokensPos, TokensNeg),
    nl, writeln('Analizando tu perfil...'),
   nl,
    calcular_y_recomendar(TokensPos, TokensNeg).

mostrar_bienvenida :-
    nl,
    writeln('=================================================='),
    writeln('       ORIENTADOR CE  |  Sistema Experto         '),
    writeln('    de Recomendacion de Carreras Universitarias   '),
    writeln('=================================================='),
    nl,
    writeln('Responde cada pregunta con tus propias palabras.'),
    writeln('No hay respuestas correctas ni incorrectas.'),
    nl.

pregunta(1, 'Que actividades o temas te apasionan en tu vida diaria o en la escuela?').
pregunta(2, 'En que materias o habilidades eres bueno? Hay alguna que te cueste trabajo?').
pregunta(3, 'Prefieres trabajar con personas, con maquinas, con ideas abstractas o con la naturaleza?').
pregunta(4, 'Que tipo de trabajo imaginas para tu futuro?Que definitivamente NO te gustaria hacer?').
pregunta(5, 'Describete brevemente: eres mas analitico, creativo, social, detallista...?').

recopilar_respuestas([], _, _, Pos, Neg, Pos, Neg).
recopilar_respuestas([_-Texto | Resto], N, Total, AccPos, AccNeg, FP, FN) :-
    nl,
    format('[ Pregunta ~w / ~w ]~n', [N, Total]),
    format('~w~n', [Texto]),
    nl, write('> '),
    leer_y_procesar(2, AccPos, AccNeg, NuevoPos, NuevoNeg),
    N1 is N + 1,
    acumular_respuestas(Resto, N1, Total, NuevoPos, NuevoNeg, FP, FN).

leer_y_procesar(0, Pos, Neg, Pos, Neg) :- !,
    writeln('[Pasando a la siguiente pregunta.]').

leer_y_procesar(Intentos, AccPos, AccNeg, FP, FN) :-
    leer_linea(Linea),
    atom_length(Linea, Len),
    (   Len =:= 0
    ->  writeln('[Respuesta vacia. Escribe algo.]'),
        nl, write('> '),
        leer_y_procesar(Intentos, AccPos, AccNeg, FP, FN)
    ;   procesar_y_acumular(Linea, Intentos, AccPos, AccNeg, FP, FN)
    ).

procesar_y_acumular(Linea, Intentos, AccPos, AccNeg, FP, FN) :-
    (   catch(parsear_respuesta(Linea, TokPos, TokNeg), _, fail)
    ->  (   TokPos = [], TokNeg = []
        ->  intentar_de_nuevo(Intentos, AccPos, AccNeg, FP, FN)
        ;   append(AccPos, TokPos, FP),
            append(AccNeg, TokNeg, FN)
        )
    ;   intentar_de_nuevo(Intentos, AccPos, AccNeg, FP, FN)
    ).

intentar_de_nuevo(Intentos, AccPos, AccNeg, FP, FN) :-
    Intentos1 is Intentos - 1,
    (   Intentos1 > 0
    ->  format('[Sin palabras clave. ~w intento(s) restante(s).]~n', [Intentos1]),
        writeln('[Ej: me gusta la tecnologia]'),
        nl, write('> '),
        leer_y_procesar(Intentos1, AccPos, AccNeg, FP, FN)
    ;   FP = AccPos, FN = AccNeg
    ).

leer_linea(Linea) :-
    read_line_to_string(user_input, Str),
    atom_string(Linea, Str).

% ============================================================
% CASOS DEMO
% ============================================================

caso_demo(tecnico,
    'Perfil tecnico',
    ['me encanta la programacion y las matematicas',
     'soy muy bueno en logica y algebra',
     'prefiero trabajar con computadoras',
     'quiero desarrollar software',
     'soy analitico y logico']).

demo :-
    nl, writeln('=================================================='),
    writeln('           MODO DEMO  |  OrientadorCE            '),
    writeln('=================================================='),
    forall(caso_demo(Nombre, _, Respuestas), ejecutar_demo(Nombre, Respuestas)).

ejecutar_demo(Nombre, Respuestas) :-
    nl, writeln('--------------------------------------------------'),
    format('DEMO: ~w~n', [Nombre]),
    writeln('--------------------------------------------------'),
    simular_respuestas(Respuestas).

simular_respuestas(Respuestas) :-
    procesar_lista(Respuestas, [], [], TPos, TNeg),
    nl, format('Tokens positivos: ~w~n', [TPos]),
    format('Tokens negativos: ~w~n', [TNeg]),
    calcular_y_recomentar(TPos, TNeg).

procesar_lista([], Pos, Neg, Pos, Neg).
procesar_lista([R | Rs], AccPos, AccNeg, FP, FN) :-
    (   catch(parsear_respuesta(R, TokPos, TokNeg), _, fail)
    ->  append(AccPos, TokPos, NewPos),
        append(AccNeg, TokNeg, NewNeg)
    ;   NewPos = AccPos, NewNeg = AccNeg
    ),
    procesar_lista(Rs, NewPos, NewNeg, FP, FN).