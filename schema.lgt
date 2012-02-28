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
    
    :- public(from_file/2).
    :- mode(from_file(+filename, -object_identifier), one).
    :- info(from_file/2, [
        comment is 'Creates a new schema from a file containing SQL',
        argnames is ['Filename', 'Schema']]).
    
    from_file(Filename, Schema) :-
        open(Filename, read, Stream),
        pio:stream_to_lazy_list(Stream, SQL),
        new(SQL, Schema).
        
    :- public(parse/1).
    :- mode(parse(+string), zero_or_one).
    
    parse(SQL) :-
        tokenizer::tokenize(SQL, Tokens),
        parser::objects(Tokens, Objects),
        self(Self), 
        meta::map([Object]>>(Self::process_object(Object)), Objects), !.
    
    :- public( [indexed/2, named/2, primary_key/2, foreign_key/4, unique/2]).
    :- dynamic([indexed/2, named/2, primary_key/2, foreign_key/4, unique/2]).
    
    :- private([process_columns/2, 
                process_column_modifiers/3]).
        
    %% process an SQL definition
    % process an index
    :- public(process_object/1).
    process_object(index(Name, Table, Columns)) :-
        ::asserta(named(Name, index)), 
        ::asserta(indexed(Table, Columns)), 
        !.
    % process a table
    process_object(table(Name, Columns)) :-
        ::asserta(named(Name, table)),
        self(Self),
        meta::map([Column]>>(Self::process_column(Name, Column)), Columns).
    % ignore anything else
    process_object(_).
    
    % process a column on a table
    :- public(process_column/2).
    process_column(TableName, column(Name, Type, Modifiers)) :-
        !,
        ::asserta(column(TableName, Name, Type)),
        meta::map([Modifier]>>process_column_modifier(TableName, Name, Modifier), Modifiers).
    process_column(_, _) :- !.
    
    process_column_modifier(Table, Column, pk) :-
        !, ::asserta(primary_key(Table, [Column])).
    process_column_modifier(Table, Column, fk(Dest,DCols)) :-
        !, ::asserta(foreign_key(Table, [Column], Dest, DCols)).
    process_column_modifier(Table, Column, fk(Dest)) :-
        !, ::primary_key(Dest, DCols),
        ::asserta(foreign_key(Table, [Column], Dest, DCols)).
    process_column_modifier(Table, Column, unique) :-
        !, ::asserta(unique(Table, [Column])).
    process_column_modifier(_, _, _) :- !.

:- end_object.