%% Pattern
:- object(repeating_groups, implements(patternp)).

    %% True if Columns is a list of columns ending in integers that share
    %% Prefix on Table.
    detect(Schema, repeating_groups(Table, Prefix, Columns)) :-
        setof(Column, 
              repeating_group_name(Schema, Table, Prefix, Column), Columns).

    % true if Atom looks like a number
    is_numeric_atom(Atom) :- catch(atom_number(Atom, _), _, fail).
    
    % utility routine: true if Column is Prefix with a number after it on
    % Table.
    repeating_group_name(Schema, Table, Prefix, Column) :-
      Schema::column(Table, Column, _), 
      atom_concat(Prefix, Num, Column), is_numeric_atom(Num).
    
:- end_object.

%% Suggestion
:- object(repeating_groups(_Table, _Prefix, _Columns), implements(suggestionp)).

    table(Table)     :- parameter(1, Table). 
    prefix(Prefix)   :- parameter(2, Prefix).
    columns(Columns) :- parameter(3, Columns).

    description(Desc) :-
        table(Table), prefix(Prefix),
        util::atom_concat(['Repeating group on ', Table, ' with name ', 
                           Prefix], 
                          Desc).
    
    sql(SQL) :-
        create_new_table(SQL1),
        migrate_data(SQL2),
        drop_columns(SQL3),
        list::append([['begin', ';'], SQL1, [';'], SQL2, [';'], SQL3, [';'], ['commit', ';']], SQL).
        
    create_new_table([create, table, NewTableName, '(', ')']) :-
        table(Table), prefix(Prefix),
        util::pluralize(Prefix, Prefixes),
        util::atom_concat([Table, '_', Prefixes], NewTableName).
        
    migrate_data([]).
    drop_columns([]).

:- end_object.
