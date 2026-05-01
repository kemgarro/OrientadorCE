% ============================================================
% orientador_main.pl  –  Integrador  |  OrientadorCE
% ============================================================
% Archivo principal - punto de entrada del sistema experto.
% Requiere los módulos: orientador_bd.pl, orientador_bnf.pl, orientador_logic.pl

:- set_prolog_flag(encoding, utf8).

:- [orientador_bd].
:- [orientador_bnf].
:- [orientador_logic].

% Inicia el programa automáticamente al cargar
:- initialization(main, main).

% main: flujo principal del programa
main :-
    mostrar_bienvenida,
    findall(N-T, pregunta(N, T), Pares),
    msort(Pares, Preguntas),
    length(Preguntas, Total),
    recopilarr_respuestas(Preguntas, 1, Total, [], [], TokensPos, TokensNeg),
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

% Las 5 preguntas que se hacen al usuario
pregunta(1, 'Que actividades o temas te apasionan en tu vida diaria o en la escuela?').
pregunta(2, 'En que materias o habilidades eres bueno? Hay alguna que te cueste trabajo?').
pregunta(3, 'Prefieres trabajar con personas, con maquinas, con ideas abstractas o con la naturaleza?').
pregunta(4, 'Que tipo de trabajo imaginas para tu futuro? Que definitivamente NO te gustaria hacer?').
pregunta(5, 'Describete brevemente: eres mas analitico, creativo, social, detallista...?').

recopilarr_respuestas([], _, _, Pos, Neg, Pos, Neg).
recopilarr_respuestas([_-Texto | Resto], N, Total, AccPos, AccNeg, FP, FN) :-
    nl,
    format('[ Pregunta ~w / ~w ]~n', [N, Total]),
    format('~w~n', [Texto]),
    nl, write('> '),
    leer_y_procesar(2, AccPos, AccNeg, NuevoPos, NuevoNeg),
    N1 is N + 1,
    recopilarr_respuestas(Resto, N1, Total, NuevoPos, NuevoNeg, FP, FN).

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

% leer_linea: lee lo que escribe el usuario
leer_linea(Linea) :-
    read_line_to_string(user_input, Str),
    atom_string(Linea, Str).

% ============================================================
% CASOS DEMO
% ============================================================
% casos_demo: ejemplos predefinidos para probar el sistema

caso_demo(tecnico,
    'Perfil tecnico: programacion, logica, matematicas',
    [
        'me encanta la programacion y las matematicas',
        'soy muy bueno en logica y algebra, me cuestan las artes',
        'prefiero trabajar con computadoras y algoritmos, no con personas',
        'quiero desarrollar software, jamas trabajaria en algo artistico',
        'soy analitico, logico y muy preciso'
    ]).

caso_demo(creativo,
    'Perfil creativo: arte, diseno, comunicacion visual',
    [
        'me apasiona el arte el diseno y los colores',
        'soy excelente dibujando, me cuestan mucho las matematicas',
        'prefiero trabajar con ideas visuales y estetica',
        'quiero disenar cosas bonitas, odio los numeros y el laboratorio',
        'soy creativo, artistico e imaginativo'
    ]).

caso_demo(social,
    'Perfil social: personas, emociones, ayuda',
    [
        'me encanta ayudar a las personas y entender sus emociones',
        'soy muy bueno comunicandome, me cuesta trabajo la tecnologia pura',
        'prefiero trabajar directamente con personas, no con maquinas',
        'quiero trabajar en terapia o educacion, no me veo en un laboratorio',
        'soy empatico, comunicativo y muy paciente'
    ]).

caso_demo(naturaleza,
    'Perfil ciencias naturales: biologia, ecologia, campo',
    [
        'me apasiona la naturaleza los animales y las plantas',
        'soy bueno en biologia y quimica, me cuesta la politica',
        'prefiero trabajar con organismos y ecosistemas al aire libre',
        'quiero investigar el medio ambiente, odio la tecnologia pura',
        'soy curioso, metodico y amante de la naturaleza'
    ]).

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
    calcular_y_recomendar(TPos, TNeg).

procesar_lista([], Pos, Neg, Pos, Neg).
procesar_lista([R | Rs], AccPos, AccNeg, FP, FN) :-
    (   catch(parsear_respuesta(R, TokPos, TokNeg), _, fail)
    ->  append(AccPos, TokPos, NewPos),
        append(AccNeg, TokNeg, NewNeg)
    ;   NewPos = AccPos, NewNeg = AccNeg
    ),
    procesar_lista(Rs, NewPos, NewNeg, FP, FN).