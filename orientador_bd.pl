n% ============================================================
% orientador_bd.pl  –  Base de Conocimiento  |  OrientadorCE
% ============================================================
%
% Estructura:
%   carrera/3          → id, nombre, descripción
%   afinidades/2       → id, temas que generan afinidad
%   fortalezas/2       → id, habilidades/rasgos favorables
%   antagonias/2       → id, temas/rasgos que penalizan el ajuste
% ============================================================

:- module(orientador_bd, [
    carrera/3,
    afinidades/2,
    fortalezas/2,
    antagonias/2
]).

% -------------------------------------------------
% CARRERAS (12 carreras)
% -------------------------------------------------

carrera(sistemas,
    'Ingeniería en Sistemas Computacionales',
    'Diseño, desarrollo y mantenimiento de software').

carrera(medicina,
    'Medicina',
    'Diagnóstico, tratamiento y prevención de enfermedades').

carrera(derecho,
    'Derecho',
    'Estudio y aplicación de normas jurídicas').

carrera(psicologia,
    'Psicología',
    'Estudio del comportamiento humano y la mente').

carrera(arquitectura,
    'Arquitectura',
    'Diseño de espacios habitables y planificación urbana').

carrera(administracion,
    'Administración de Empresas',
    'Gestión estratégica de recursos en organizaciones').

carrera(civil,
    'Ingeniería Civil',
    'Diseño y construcción de infraestructura').

carrera(diseno,
    'Diseño Gráfico',
    'Creación de comunicaciones visuales y branding').

carrera(biologia,
    'Biología',
    'Estudio de los seres vivos y ecosistemas').

carrera(educacion,
    'Educación / Pedagogía',
    'Formación y enseñanza orientada al desarrollo humano').

carrera(electronica,
    'Ingeniería Electrónica',
    'Diseño de circuitos y sistemas de control').

carrera(comunicacion,
    'Comunicación Colectiva',
    'Producción periodística y medios digitales').

% -------------------------------------------------
% AFINIDADES
% -------------------------------------------------

afinidades(sistemas, [tecnologia, programacion, computadoras, matematicas, datos, logica, software, videojuegos, redes]).

afinidades(medicina, [salud, biologia, anatomia, quimica, ayudar, pacientes, hospital]).

afinidades(derecho, [justicia, leyes, politica, argumentacion, debate, historia, etica]).

afinidades(psicologia, [personas, comportamiento, mente, emociones, ayudar, terapia]).

afinidades(arquitectura, [arte, construccion, espacio, geometria, estetica, disenio]).

afinidades(administracion, [negocios, empresas, economia, finanzas, liderazgo, estrategia]).

afinidades(civil, [construccion, matematicas, fisica, infraestructura, estructuras, calculo]).

afinidades(diseno, [arte, creatividad, visual, color, ilustracion, fotografia, estetica]).

afinidades(biologia, [naturaleza, animales, plantas, ecologia, laboratorio, investigacion]).

afinidades(educacion, [enseniar, ninos, jovenes, pedagogia, comunidad, personas]).

afinidades(electronica, [circuitos, fisica, robotica, automatizacion, hardware, programacion]).

afinidades(comunicacion, [medios, periodismo, escritura, creatividad, fotografia, cine]).

% -------------------------------------------------
% FORTALEZAS
% -------------------------------------------------

fortalezas(sistemas, [analitico, logico, preciso, concentrado]).

fortalezas(medicina, [memorioso, dedicado, empatico, responsable]).

fortalezas(derecho, [argumentativo, critico, persuasivo, lector, organizado]).

fortalezas(psicologia, [empatico, comunicativo, reflexivo, observador]).

fortalezas(arquitectura, [creativo, espacial, artistico, preciso, planificador]).

fortalezas(administracion, [lider, organizado, estrategico, negociador]).

fortalezas(civil, [logico, preciso, planificador, detallista]).

fortalezas(diseno, [creativo, visual, artistico, imaginativo]).

fortalezas(biologia, [curioso, observador, metodico, paciente]).

fortalezas(educacion, [comunicativo, empatico, paciente, creativo]).

fortalezas(electronica, [logico, analitico, detallista, tecnico]).

fortalezas(comunicacion, [creativo, comunicativo, curioso, sociable]).

% -------------------------------------------------
% ANTAGONÍAS
% -------------------------------------------------

antagonias(sistemas, [arte_visual, musica, deporte, naturaleza]).

antagonias(medicina, [tecnologia_pura, matematicas, arte]).

antagonias(derecho, [laboratorio, trabajo_manual, ciencias_exactas]).

antagonias(psicologia, [tecnologia_pura, matematicas, laboratorio]).

antagonias(arquitectura, [ciencias_puras, rechazo_arte]).

antagonias(administracion, [ciencias_exactas, laboratorio, arte]).

antagonias(civil, [arte, humanidades, escritura_intensiva]).

antagonias(diseno, [matematicas_avanzadas, ciencias_exactas]).

antagonias(biologia, [tecnologia_pura, arte, politica]).

antagonias(educacion, [tecnologia_profunda, trabajo_solitario]).

antagonias(electronica, [arte, humanidades, escritura_intensiva]).

antagonias(comunicacion, [matematicas, ciencias_exactas, trabajo_solitario]).