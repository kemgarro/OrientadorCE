% ============================================================
% orientador_main.pl  –  Integrador  |  OrientadorCE
% ============================================================
%
% Este archivo es el punto de entrada del sistema experto.
% Requiere orientador_bd.pl, orientador_bnf.pl y orientador_logic.pl
%
% USO:
%   $ swipl orientador_main.pl
%   ?- iniciar.
%
% Este archivo se IRA COMPLETANDO en commits posteriores.
% ============================================================

:- use_module('orientador_bd.pl').
:- use_module('orientador_bnf.pl').
:- use_module('orientador_logic.pl').

% Por completar en commits posteriores:
% - initialization
% - iniciar/0
% - preguntas del sistema
% - casos demo