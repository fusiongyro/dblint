%% True if Column on Table is a foreign key but is not
%% indexed.
missing_foreign_key_index(Table, Column) :-
  foreign_key(Table, Column, _, _), 
  \+ index(Table, Column).


