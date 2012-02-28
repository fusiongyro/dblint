:- object(unnecessary_surrogate_key, implements(patternp)).

    detect(Schema, unnecessary_surrogate_key(Table, OldId, NewId, Schema)) :-
      Schema::primary_key(Table, [OldId]),
      Schema::column(Table, OldId, serial),
      Schema::unique(Table, NewId).

:- end_object.

:- object(unnecessary_surrogate_key(_Table, _OldId, _NewId, _Schema), implements(suggestionp)).

    table(Table) :- parameter(1, Table).
    new_id(NewId) :- parameter(3, NewId).

    description(Desc) :-
        table(Table), new_id(NewId), parser::identifiers(NewIdColumns, NewId),
        util::atom_concat(NewIdColumns, NewIdText),
        util::atom_concat(['Unnecessary surrogate key on ', Table, ' (use ', NewIdText, ' instead)'], Desc).
    
    sql(SQL) :-
        table(Table), parameter(2, OldId), new_id(NewId),
        parser::identifiers(NewIdColumns, NewId),
        % prior to altering the table, we must modify any foreign keys that point to this database
        % Schema::foreign_key(Source, SCols, Table, [OldId]) ...
        list::append([[alter,table,Table,drop,column,OldId,',',add,primary,key,'('],NewIdColumns,[')',';']], SQL).

:- end_object.