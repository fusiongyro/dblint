:- object(missing_schema, implements(patternp)).

    :- public(table_names/2).
    table_names(Schema, TableNames) :- 
        setof(TableName, Schema::named(TableName, table), TableNames).

    detect(Schema, missing_schema(Schema, Prefix)) :-
        table_names(Schema, TableNames),
        setof(APrefix, missing_schema(TableNames, APrefix), Prefixes),
        last(Prefixes, Prefix),
        Prefix \= ''.
    
    :- public(missing_schema/2).
    missing_schema([Name1|OtherNames], Prefix) :-
        atom_concat(Prefix, _, Name1),
        forall(lists::member(Name, OtherNames), atom_concat(Prefix, _, Name)).

:- end_object.

:- object(missing_schema(_Schema, _Prefix), implements(suggestionp)).

    schema(Schema) :- parameter(1, Schema).
    prefix(Prefix) :- parameter(2, Prefix).

    description(Desc) :-
        prefix(Prefix),
        util::atom_concat(['Replace common table prefix ', Prefix, ' with schema'], Desc).
    
    sql(SQL) :-
        schema(Schema),
        missing_schema::table_names(Schema, TableNames),
        rename_tables_loop(TableNames, TablesSQL),
        list::flatten(TablesSQL, SQL).
    
    rename_tables_loop([Table|Tables], [SQL|SQLs]) :-
        rename_table(Table, SQL), 
        rename_tables_loop(Tables, SQLs).
    rename_tables_loop([], []).
    
    rename_table(OldTableName, [alter,table,OldTableName,rename,to,NewTableName,';']) :-
        prefix(Prefix),
        atom_concat(Prefix, NewTableName, OldTableName).

:- end_object.