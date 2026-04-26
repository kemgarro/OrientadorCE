% ============================================================
% orientador_bnf.pl  –  Parser de Lenguaje Natural  |  OrientadorCE
% ============================================================
%
% Módulo de parsing de lenguaje natural.
% Este archivo se IRA COMPLETANDO en commits posteriores.
%
% POR AHOR: solo tokenizador básico.
% ============================================================

:- module(orientador_bnf, [
    tokenizar/2
    % - parsear_respuesta/3 se agregará en Commit 5
    % - sinonimo/2 se agregará en Commit 5
    % - detectar_marcador/3 se agregará en Commit 5
    % - reglas DCG con --> se agregarán en Commit 4
]).

:- use_module(library(lists)).

% -------------------------------------------------
% TOKENIZADOR BÁSICO (solo minúsculas)
% Por completar:
% - sinónimos (Commit 5)
% - DCG con --> (Commit 4)
% - marcadores positivos/negativos (Commit 5)
% -------------------------------------------------

tokenizar(Linea, Tokens) :-
    atom_string(Linea, Str),
    string_lower(Str, Lower),
    split_string(Lower, " ,;.:!?()/\\\"'-", "", Partes),
    include([P]>>(P \= ""), Partes, Tokens).

% Por completar:
% - parsear_respuesta/3
% - sinonimo/2
% - detectar_marcador/3
% - DCG con -->