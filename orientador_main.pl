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