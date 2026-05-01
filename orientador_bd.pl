% ============================================================
% orientador_bd.pl  –  Base de Conocimiento  |  OrientadorCE
% ============================================================
% Base de datos con las 17 carreras disponibles y sus características
% estructura:
%   carrera/3          → id, nombre, descripción
%   afinidades/2      → temas que le gustan a esta carrera
%   fortalezas/2       → habilidades que necesita esta carrera
%   antagonias/2      → temas que no van con esta carrera
% ============================================================

:- module(orientador_bd, [
    carrera/3,
    afinidades/2,
    fortalezas/2,
    antagonias/2
]).

% CARRERAS - las 17 carreras que el sistema puede recomendar
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

carrera(gastronomia,
    'Gastronomía',
    'Arte culinario, dirección de cocina y gestión de restaurantes').

carrera(fisica,
    'Física',
    'Investigación científica, física teórica y aplicada, laboratorio').

carrera(ingenieria_fisica,
    'Ingeniería Física',
    'I+D tecnológico, física aplicada, innovación y desarrollo de tecnologías').

carrera(aeroespacial,
    'Ingeniería Aeroespacial',
    'Diseño y desarrollo de aeronaves, tecnología espacial y sistemas de vuelo').

carrera(mecatronica,
    'Ingeniería Mecatrónica',
    'Robótica, automatización, sistemas inteligentes y tecnología avanzada').

% AFINIDADES - temas que le gustan a cada carrera
% Si el usuario menciona estos temas, la carrera suma puntos
% -------------------------------------------------

afinidades(sistemas, [tecnologia, programacion, computadoras, matematicas, datos, logica, software, videojuegos, redes, computacion, informatica, algoritmos, base_datos, seguridad, desarrollo_web, inteligencia_artificial, machine_learning, ciberseguridad, soporte_tecnico, frontend, backend]).

afinidades(medicina, [salud, biologia, anatomia, quimica, ayudar, pacientes, hospital, fisiologia, patologia, farmacologia, clinica, cirugia, pediatria, emergencia, salud_mental, prevencion, diagnostico, tratamiento, rehabilitacion, epidemiologia]).

afinidades(derecho, [justicia, leyes, politica, argumentacion, debate, historia, etica, jurisprudencia, derecho_civil, derecho_penal, derecho_constitucional, derecho_laboral, derecho_internacional, litigio, contratos, redactar, investigacion_juridica]).

afinidades(psicologia, [personas, comportamiento, mente, emociones, ayudar, terapia, psicologia_clinica, psicologia_educativa, psicologia_organizacional, salud_mental, desarrollo_humano, counseling, evaluacion_psicologica, entrevistas, diagnostico, tratamiento_psicologico]).

afinidades(arquitectura, [arte, construccion, espacio, geometria, estetica, disenio, diseno_arquitectonico, urbanismo, planos, modelado_3d, materiales, estructuras, proyectos, diseno_interiores, paisajismo, sustentabilidad, accesibilidad]).

afinidades(administracion, [negocios, empresas, economia, finanzas, liderazgo, estrategia, gestion_empresarial, recursos_humanos, marketing, operaciones, logistica, emprendimiento, contaduria, auditoria, planeacion, analisis_financiero, toma_decisiones, negocios_internacionales]).

afinidades(civil, [construccion, matematicas, fisica, infraestructura, estructuras, calculo, ingenieria_estructural, obras_civiles, hydraulica, geotecnia, transporte, carreteras, puentes, edificaciones, planos_constructivos, gestion_proyectos, supervision_obra, materiales_construccion]).

afinidades(diseno, [arte, creatividad, visual, color, ilustracion, fotografia, estetica, diseno_grafico, diseno_industrial, diseno_web, diseno_ui, diseno_ux, tipografia, branding, publicidad, comunicacion_visual, animacion, motion_graphics, identidad_visual]).

afinidades(biologia, [naturaleza, animales, plantas, ecologia, laboratorio, investigacion, biologia_molecular, genetica, microbiologia, bioquimica, biologia_marina, conservacion, biotecnologia, fisiologia, taxonomia, evolucion, biodiversidad]).

afinidades(educacion, [enseniar, ninos, jovenes, pedagogia, comunidad, personas, didactica, planificacion, evaluacion, tutoria, orientacion, formacion, capacitacion, educacion_especial, educacion_inclusiva, tecnologia_educativa, metodologias_ensenanza]).

afinidades(electronica, [circuitos, fisica, robotica, automatizacion, hardware, programacion, electronica_digital, electronica_analogica, microcontroladores, sistemas_embebidos, telecomunicaciones, senal, procesamiento, control_industrial, instrumentacion, diseno_electronico]).

afinidades(comunicacion, [medios, periodismo, escritura, creatividad, fotografia, cine, comunicacion_social, comunicacion_digital, production_audiovisual, locucion, presentacion, redaccion_periodistica, entrevista, produccion_televisiva, production_radio, community_management]).

afinidades(gastronomia, [cocina, alimentacion, gastronomia, comida, restauracion, nutricion, servicio, chefs, culinaria, reposteria, alta_cocina, restaurantes, gestion_restaurante, chef_profesional, panaderia, reposteria_artistica, alta_gastronomia, alimentacion_saludable, gestion_cocina]).

% Nuevas carreras - Afinidades
afinidades(fisica, [fisica, matematicas, investigacion, laboratorio, ciencia, teoria, calculo, analisis, experimentacion, fisica_cuantica, astronomia, universo, formulas, ecuaciones,modelado, simulacion]).

afinidades(ingenieria_fisica, [matematicas, fisica, tecnologia, investigacion, desarrollo, innovacion, laboratorio, ingenieria, modelado, simulacion, circuits, sensores, sistemas, fisica_aplicada, instrumentacion]).

afinidades(aeroespacial, [espacio, fisica, matematicas, ingenieria, nasa, aeronaves, aerodinamica, tecnologia, investigacion, laboratorio, vuelo, satelite, cohete, orbita, astronauta, astronomia, espacio, aeroespacial]).

afinidades(mecatronica, [robotica, automatizacion, tecnologia, electronica, mecanica, sistemas, programacion, sensores, circuitos, ingenieria, innovacion, desarrollo, maquinas, control, inteligencia, automata]).

% FORTALEZAS - habilidades que necesita cada carrera
% Si el usuario tiene estas características, la carrera suma puntos
% -------------------------------------------------

fortalezas(sistemas, [analitico, logico, preciso, concentrado, metodico, sistematico, autodidacta, resolutivo, detallista, tecnico, paciente, persistente, competitivo, eficiente]).

fortalezas(medicina, [memorioso, dedicado, empatico, responsable, compasivo, observador, calmado, comunicativo, analitico, practico, tolerante, servicial, integro]).

fortalezas(derecho, [argumentativo, critico, persuasivo, lector, organizado, analitico, reflexivo, metodoico, logical, investigativo, comunicativo, escrito, estratega]).

fortalezas(psicologia, [empatico, comunicativo, reflexivo, observador, sensible, paciente, listening, intuitivo, terbuka, stable, analitico, compasivo, facilitador, trustworthy]).

fortalezas(arquitectura, [creativo, espacial, artistico, preciso, planificador, visual, innovator, detallista, observador, estetico, sistematica, project_manager, visionary]).

fortalezas(administracion, [lider, organizado, estrategico, negociador, comunicativo, decisive, proactive, analitico, flexible, adaptable, ambicius, relational, team_leader]).

fortalezas(civil, [logico, preciso, planificador, detallista, metodico, tecnico, analitico, pratico, eficiente, calculated, resolutivo, sistematica]).

fortalezas(diseno, [creativo, visual, artistico, imaginativo, innovadora, estetico, detallista, comunicativo, flexible, abierta, observant, conceptual, branding]).

fortalezas(biologia, [curioso, observador, metodico, paciente, analitico, investigativo, sistematica, detallista, logical, persistente, naturalist, scientific_minded]).

fortalezas(educacion, [comunicativo, empatico, paciente, creativo, paciente, motivador, listening, adaptable, organizativo, innovator, collaborator, facilitador]).

fortalezas(electronica, [logico, analitico, detallista, tecnico, metodico, practica, resuelto, precision, sistematica, manual, inventor, engineer_mind]).

fortalezas(comunicacion, [creativo, comunicativo, curioso, sociable, expresivo, storyteller, persuasivo, abierta, energetico, relational, adaptable, media_savvy]).

fortalezas(gastronomia, [creativo, organizador, limpio, servicio, puntual, trabajo_en_equipo, chef, gestion, detallista, artistico, productiva, efficient, pressure_proof, team_player, passionate]).

fortalezas(fisica, [analitico, curioso, metodico, observador, teorico, paciente, logico, abstracto, dedicado, investigador, matematico, conceptual, riguroso, imaginativo, persistente]).

fortalezas(ingenieria_fisica, [analitico, logico, innovativo, metodico, practico, resolutivo, curioso, detallista, inventor, tecnico, sistematica, creativo, practica, ingenioso]).

fortalezas(aeroespacial, [analitico, preciso, innovador, detallado, tecnico, visionario, calculista, espacial, sistemico, curioso, rigoroso, paciente, ingeniero, detallado]).

fortalezas(mecatronica, [logico, analitico, tecnico, practico, innovador, resolutivo, manual, espacial, programable, sistemico, mecanico, electronico, automatizado, inventor]).

% Nuevas carreras - Fortalezas
fortalezas(fisica, [analitico, curioso, metodico, observador, teorico, paciente, logico, abstracto, dedicado, investigador]).

fortalezas(ingenieria_fisica, [analitico, logico, innovativo, metodico, practico, resolutivo, curiouso, detallista, inventor, tecnico]).

fortalezas(aeroespacial, [analitico, preciso, innovador, detallado, tecnico, visionario, calculista, espacial, sistemico, curioso]).

fortalezas(mecatronica, [logico, analitico, tecnico, practico, innovador, resolutivo, manual, espacial, programable, sistemico]).

% ANTAGONÍAS - temas que no van bien con cada carrera
% Si el usuario menciona estos temas, la carrera pierde puntos
% -------------------------------------------------

antagonias(sistemas, [arte_visual, musica, deporte, naturaleza, trabajo_manual, trabajo_social, escritura, literatura, filosofia, historia, teatro, danza]).

antagonias(medicina, [tecnologia_pura, matematicas, arte, programacion, construccion, economia, negocios, filosofia, historia_arte]).

antagonias(derecho, [laboratorio, trabajo_manual, ciencias_exactas, biologia, fisica, quimica, programacion, matematicas_avanzadas, tecnologia]).

antagonias(psicologia, [tecnologia_pura, matematicas, laboratorio, programacion, fisica, quimica, ingenieria, construccion, matematicas_avanzadas]).

antagonias(administracion, [ciencias_exactas, laboratorio, arte, investigacion_pura, fisica, biologia, quimica, matematicas_avanzadas, filosofia, historia]).

antagonias(civil, [arte, humanidades, escritura_intensiva, filosofia, literatura, psicologia, arte_visual, musica, teatro, programacion, quimica_pura]).

antagonias(diseno, [matematicas_avanzadas, ciencias_exactas, fisica, quimica, biologia, programacion, laboratorio, investigacion, economia, finanzas, derecho]).

antagonias(comunicacion, [matematicas, ciencias_exactas, trabajo_solitario, programacion, fisica, quimica, biologia, laboratorio, matematicas_avanzadas]).

antagonias(gastronomia, [oficina, trabajo_sedentario, tecnologia_profunda, matematicas_avanzadas, ciencias_exactas, trabajo_solitario, programacion, fisica_cuantica, biologia_molecular]).

antagonias(fisica, [trabajo_manual, construccion, obra, ventas, trabajo_repetitivo, oficinas, marketing, empresas, negocios, arte_visual, trabajo_fisico, arte, literatura, derecho]).

antagonias(ingenieria_fisica, [trabajo_manual, construccion, arte_visual, trabajo_social, ventas, marketing, trabajo_repetitivo, trabajo_fisico, filosofia, literatura, derecho]).

antagonias(aeroespacial, [trabajo_social, arte_visual, construccion, ventas, marketing, trabajo_manual_exigente, trabajo_repetitivo, trabajo_social, oficina_repetitiva, literatura, musica, teatro]).

antagonias(mecatronica, [trabajo_social, arte_visual, trabajo_de_oficina, ventas, marketing, humanidades, literatura, trabajo_repetitivo, filosofia, derecho, psicologia, trabajo_solitario]).

% Nuevas carreras - Antagonías
antagonias(fisica, [trabajo_manual, construccion, obra, ventas, trabajo_repetitivo, oficinas, marketing, empresas, negocios, arte_visual, trabajo_fisico]).

antagonias(ingenieria_fisica, [trabajo_manual, construccion, arte_visual, trabajo_social, ventas, marketing, trabajo_repetitivo, trabajo_fisico]).

antagonias(aeroespacial, [trabajo_social, arte_visual, construccion, ventas, marketing, trabajo_manual_exigente, trabajo_repetitivo, trabajo_social, oficina_repetitiva]).

antagonias(mecatronica, [trabajo_social, arte_visual, trabajo_de_oficina, ventas, marketing, humanidades, literatura, trabajo_repetitivo]).