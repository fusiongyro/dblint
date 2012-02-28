%% Pattern
:- object(missing_foreign_key_index, implements(patternp)).

    detect(Schema, missing_foreign_key_index(Table, Column)) :-
        Schema::foreign_key(Table, Column, _, _), 
        \+ Schema::index(Table, Column).

:- end_object.

%% Suggestion
:- object(missing_foreign_key_index(_Table, _Column), implements(suggestionp)).

    table(Table) :- parameter(1, Table).
    column(Column) :- parameter(2, Column).

    description(Desc) :-
        table(Table), column(Column),
        parser::identifiers(ColumnIdents, Column), 
        util::atom_concat(ColumnIdents, Columns),
        util::atom_concat(['Unindexed foreign key on ', Table, ' (', Columns, ')'], Desc).
        
    sql(SQL) :-
        table(Table), column(Column),
        parser::identifiers(ColumnIdents, Column),
        list::append([create, index, on, Table, '('], ColumnIdents, FirstHalf),
        list::append(FirstHalf, [')'], SQL).

:- end_object.