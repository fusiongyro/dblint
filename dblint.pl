%% dbsuggest.pl
%%
%% Analyzes relational database structure and makes suggestions for 
%% improvements.

%% these are examples of the kinds of suggestions we could implement.

:- discontiguous(suggestion/2).
:- [structure, util, suggestions].

%% later on, to support various databases:
%% :- discontiguous(generate_sql/3).
%% generate_sql(add_foreign_key(D, F, S, P), oracle, Sql) :- ...
%% generate_sql(add_foreign_key(D, F, S, P), _, Sql) :- ...
