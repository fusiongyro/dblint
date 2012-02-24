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

