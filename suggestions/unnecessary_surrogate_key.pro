%% True if Table has a candidate key NewId but already has a primary
%% key OldId that appears to be a surrogate key.
unnecessary_surrogate_key(Table, OldId, NewId) :-
  primary_key(Table, OldId),
  column(Table, OldId, integer),
  unique(Table, NewId).

