:- object(schema,
    instantiates(schema),
    implements(schemap)).
    
    :- public(new/2).
    :- mode(new(+string, -object_identifier), one).
    :- info(new/2, [
        comment is 'Creates a new schema from some SQL',
        argnames is ['SQL', 'Schema']]).
    
    new(SQL, Schema) :-
        self(Self),
        create_object(Schema, [instantiates(Self)], [], []),
        Schema::parse(SQL).
        
    :- public(parse/1).
    :- mode(parse(+string), zero_or_one).
    
    parse(SQL) :-
        tokenizer::tokenize(SQL, Tokens),
        parser::objects(Tokens, Objects),
        process_objects(Objects), !.
    
    :- public( [indexed/2, named/2, primary_key/2, foreign_key/4, unique/2]).
    :- dynamic([indexed/2, named/2, primary_key/2, foreign_key/4, unique/2]).
    
    :- private([process_objects/1, 
                process_object/1, 
                process_columns/2, 
                process_column_modifiers/3]).
    
    %% process all the sorts of things that can appear in an SQL script
    process_objects([Object|Objects]) :- 
        process_object(Object), process_objects(Objects), !.
    process_objects([]).
    
    %% process an SQL definition
    % process an index
    process_object(index(Name, Table, Columns)) :-
        ::asserta(named(Name, index)), 
        ::asserta(indexed(Table, Columns)), 
        !.
    % process a table
    process_object(table(Name, Columns)) :-
        ::asserta(named(Name, table)),
        process_columns(Name, Columns).
    % ignore anything else
    process_object(_).
    
    % process all the columns on a table
    process_columns(TableName, [Col|Rest]) :-
        process_column(TableName, Col),
        process_columns(TableName, Rest).
    
    % process a column on a table
    process_column(TableName, column(Name, Type, Modifiers)) :-
        ::asserta(column(TableName, Name, Type)),
        process_column_modifiers(TableName, Name, Modifiers).
    
    % process all the column modifiers that may occur on a column
    process_column_modifiers(_, _, []).
    process_column_modifiers(Table, Column, [Mod|Rest]) :-
        process_column_modifier(Table, Column, Mod),
        process_column_modifiers(Table, Column, Rest).
        
    process_column_modifier(Table, Column, pk) :-
        !, ::asserta(primary_key(Table, [Column])).
    process_column_modifier(Table, Column, fk(Dest,DCols)) :-
        !, ::asserta(foreign_key(Table, [Column], Dest, DCols)).
    process_column_modifier(Table, Column, fk(Dest)) :-
        !,
        ::primary_key(Dest, DCols),
        ::asserta(foreign_key(Table, [Column], Dest, DCols)).
    process_column_modifier(Table, Column, unique) :-
        !,
        ::asserta(unique(Table, [Column])).

:- end_object.