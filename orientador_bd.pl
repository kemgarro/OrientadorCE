% ============================================================
% orientador_bd.pl  –  Base de Conocimiento  |  OrientadorCE
% ============================================================
%
% Estructura:
%   carrera/3     → id, nombre, descripción
%
% Este archivo se IRA COMPLETANDO en commits posteriores.
% Por ahora solo 2 carreras básicas.
% ============================================================

:- module(orientador_bd, [
    carrera/3
    % - afinidades/2 se agregará en Commit 3
    % - fortalezas/2 se agregará en Commit 3
    % - antagonias/2 se agregará en Commit 3
]).

% -------------------------------------------------
% CARRERAS (solo 2 por ahora)
% -------------------------------------------------

carrera(sistemas,
    'Ingeniería en Sistemas Computacionales',
    'Diseño, desarrollo y mantenimiento de software').

carrera(medicina,
    'Medicina',
    'Diagnóstico, tratamiento y prevención de doenças humanas').

% Por completar:
% - derecho, psicologia, arquitectura, etc.
% - afinidades, fortalezas, antagonias