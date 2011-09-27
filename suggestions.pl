:- [suggestions/missing_foreign_key_index].
:- [suggestions/unnecessary_surrogate_key].
:- [suggestions/repeating_groups].
:- [suggestions/missing_foreign_key].

suggestion(remove_redundant_pk(Table, OldId, NewId), 
          'Surrogate used in place of natural key') :-
  unnecessary_surrogate_key(Table, OldId, NewId).

suggestion(extract_repeating_group(Table, Prefix, Columns), 'Repeating group') :-
  repeating_groups(Table, Prefix, Columns).

suggestion(add_index(Table, Column), 'Unindexed foreign key') :-
  missing_foreign_key_index(Table, Column).

suggestion(add_foreign_key(Destination, FK, Source, PK), 'Missing foreign key') :-
  missing_foreign_key(Destination, FK, Source, PK).

