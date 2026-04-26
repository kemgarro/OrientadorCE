% ============================================================
% orientador_bnf.pl  –  Parser de Lenguaje Natural  |  OrientadorCE
% ============================================================
%
% Módulo de parsing de lenguaje natural.
% Por ahora: solo tokenizador básico.
% ============================================================

:- module(orientador_bnf, [
    tokenizar/2
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