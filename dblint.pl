%% dbsuggest.pl
%%
%% Analyzes relational database structure and makes suggestions for 
%% improvements.

%% these are examples of the kinds of suggestions we could implement.
column(managers, id, integer).

column(users, id, integer).
column(users, name, varchar).
column(users, manager_id, integer).

column(projects, id, integer).
column(projects, user_id, integer).
column(projects, tag1, varchar).
column(projects, tag2, varchar).
column(projects, tag3, varchar).
column(projects, access1, varchar).
column(projects, access2, varchar).

primary_key(users, id).

unique(users, name).

foreign_key(projects, user_id, users, id).

index(users, id).
index(projects, id).

%% True if Column on Table is a foreign key but is not
%% indexed.
missing_foreign_key_index(Table, Column) :-
  foreign_key(Table, Column, _, _), 
  \+ index(Table, Column).

%% True if Table has a candidate key NewId but already has a primary
%% key OldId that appears to be a surrogate key.
unnecessary_primary_key(Table, OldId, NewId) :-
  primary_key(Table, OldId),
  column(Table, OldId, integer),
  unique(Table, NewId).

%% True if Columns is a list of columns ending in integers that share
%% Prefix on Table.
repeating_groups(Table, Prefix, Columns) :-
  setof(Column, repeating_group_name(Table, Prefix, Column), Columns).

%% True if FK is a foreign key to the Source table
foreign_key_name(Source, FK) :-
  nonvar(Source), !,
  pluralize(SourceCol, Source),
  atom_concat(SourceCol, '_id', FK).
foreign_key_name(Source, FK) :-
  nonvar(FK), !,
  atom_concat(SourceCol, '_id', FK),
  pluralize(SourceCol, Source).

%% True if Destination table's column FK looks like a foreign key to
%% Source table's PK.
missing_foreign_key(Destination, FK, Source, id) :-
  column(Destination, FK, _),
  foreign_key_name(Source, FK),
  column(Source, id, _),
  \+ foreign_key(Destination, FK, Source, _).

%% Generates a set of suggestions for improvements to this database
%% using the tests defined above.
suggestion(add_index(Table, Column), 'Unindexed foreign key') :-
  missing_foreign_key_index(Table, Column).
suggestion(remove_redundant_pk(Table, OldId, NewId), 
          'Surrogate used in place of natural key') :-
  unnecessary_primary_key(Table, OldId, NewId).
suggestion(extract_repeating_group(Table, Prefix, Columns), 'Repeating group') :-
  repeating_groups(Table, Prefix, Columns).
suggestion(add_foreign_key(Destination, FK, Source, PK), 'Missing foreign key') :-
  missing_foreign_key(Destination, FK, Source, PK).


% utility functions

% true if Atom looks like a number
is_numeric_atom(Atom) :- catch(atom_number(Atom, _), _, fail).

% utility routine: true if Column is Prefix with a number after it on
% Table.
repeating_group_name(Table, Prefix, Column) :-
  column(Table, Column, _), 
  atom_concat(Prefix, Num, Column), is_numeric_atom(Num).

% utility routine: expresses relationship between singular and plural.
pluralize(Foo, Foos) :- atom_concat(Foo, s, Foos).


%% later on, to support various databases:
%% :- discontiguous(generate_sql/3).
%% generate_sql(add_foreign_key(D, F, S, P), oracle, Sql) :- ...
%% generate_sql(add_foreign_key(D, F, S, P), _, Sql) :- ...
