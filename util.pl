% true if Atom looks like a number
is_numeric_atom(Atom) :- catch(atom_number(Atom, _), _, fail).

% utility routine: expresses relationship between singular and plural.
pluralize(Foo, Foos) :- atom_concat(Foo, s, Foos).
