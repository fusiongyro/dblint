%% True if Columns is a list of columns ending in integers that share
%% Prefix on Table.
repeating_groups(Table, Prefix, Columns) :-
  setof(Column, repeating_group_name(Table, Prefix, Column), Columns).

% utility routine: true if Column is Prefix with a number after it on
% Table.
repeating_group_name(Table, Prefix, Column) :-
  column(Table, Column, _), 
  atom_concat(Prefix, Num, Column), is_numeric_atom(Num).
