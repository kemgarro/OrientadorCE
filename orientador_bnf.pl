% ============================================================
% orientador_bnf.pl  –  Parser de Lenguaje Natural  |  OrientadorCE
% ============================================================

:- module(orientador_bnf, [
    tokenizar/2,
    sinonimo/2
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