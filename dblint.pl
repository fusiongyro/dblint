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

missing_foreign_key_index(Table, Column) :-
  foreign_key(Table, Column, _, _), 
  \+ index(Table, Column).

unnecessary_primary_key(Table, OldId, NewId) :-
  primary_key(Table, OldId),
  column(Table, OldId, integer),
  unique(Table, NewId).

repeating_groups(Table, Prefix, Columns) :-
  setof(Column, repeating_group_name(Table, Prefix, Column), Columns).

repeating_group_name(Table, Prefix, Column) :-
  column(Table, Column, _), 
  atom_concat(Prefix, Num, Column), is_numeric_atom(Num).

pluralize(Foo, Foos) :- atom_concat(Foo, s, Foos).

foreign_key_name(Source, FK) :-
  nonvar(Source), !,
  pluralize(SourceCol, Source),
  atom_concat(SourceCol, '_id', FK).
foreign_key_name(Source, FK) :-
  nonvar(FK), !,
  atom_concat(SourceCol, '_id', FK),
  pluralize(SourceCol, Source).

missing_foreign_key(Destination, FK, Source, id) :-
  column(Destination, FK, _),
  foreign_key_name(Source, FK),
  column(Source, id, _),
  \+ foreign_key(Destination, FK, Source, _).

suggestion(add_index(Table, Column), 'Unindexed foreign key') :-
  missing_foreign_key_index(Table, Column).
suggestion(remove_redundant_pk(Table, OldId, NewId), 
          'Surrogate used in place of natural key') :-
  unnecessary_primary_key(Table, OldId, NewId).
suggestion(extract_repeating_group(Table, Columns), 'Repeating group on table') :-
  repeating_groups(Table, _, Columns).



% utility functions
is_numeric_atom(Atom) :- catch(atom_number(Atom, _), _, fail).