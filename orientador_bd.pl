% ============================================================
% orientador_bd.pl  –  Base de Conocimiento  |  OrientadorCE
% ============================================================
%
% Estructura:
%   carrera/3     → id, nombre, descripción
%
% Este archivo se IRA COMPLETANDO en commits posteriores.
% Por ahora solo 4 carreras básicas.
% ============================================================

:- module(orientador_bd, [
    carrera/3
    % - afinidades/2 se agregará en Commit 3
    % - fortalezas/2 se agregará en Commit 3
    % - antagonias/2 se agregará en Commit 3
]).

% -------------------------------------------------
% CARRERAS (4 por ahora)
% -------------------------------------------------

carrera(sistemas,
    'Ingeniería en Sistemas Computacionales',
    'Diseño, desarrollo y mantenimiento de software').

carrera(medicina,
    'Medicina',
    'Diagnóstico, tratamiento y prevención de enfermedades humanas').

carrera(derecho,
    'Derecho',
    'Estudio y aplicación de normas jurídicas que regulan la sociedad').

carrera(psicologia,
    'Psicología',
    'Estudio del comportamiento humano, la mente y la salud mental').

% Por completar:
% - más carreras (arquitectura, administración, etc.)
% - afinidades, fortalezas, antagonias