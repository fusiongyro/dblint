:- object(parser).

    :- info([comment is 'Parses SQL.']).
    

    :- public(parse/2).
    :- mode(parse(+list, -list), zero_or_one).
    :- info(parse/2, [
        comment is 'Returns a list of parsed objects from the SQL provided.',
        argnames is ['Codes', 'Objects']]).

    parse(Codes, Objects) :- 
        tokenizer::tokenize(Codes, Tokens),
        objects(Tokens, Objects).

    :- public(objects/2).
    :- mode(objects(+list, -list), zero_or_one).
    :- info(objects/2, [
        comment is 'Converts between a list of tokens and a list of objects.',
        argnames is ['Tokens', 'Objects']]).
    
    objects(Tokens, Objects) :- phrase(objects(Objects), Tokens).
    
    :- public(identifiers/2).
    :- mode(identifiers(+list, -list), one).
    :- mode(identifiers(-list, +list), one).
    :- info(identifiers/2, [
        comment is 'Translates between SQL lists of identifiers and Prolog lists of identifiers.',
        argnames is ['SQLIdentifiers', 'Identifiers']]).
    
    identifiers(SQLIdentifiers, Identifiers) :- phrase(identifiers(Identifiers), SQLIdentifiers).
    
    % parsing basic SQL create statements
    
    % our intermediate representation here is this:
    % table(Name, Columns) 
    %   -- Name is an atom, the name of this table
    %   -- Columns is a list of column relations:
    %
    % column(Name, Type, Modifiers)
    %   -- Name :- atom, name of this table
    %   -- Type :- atom or relation representing type, e.g. 'integer' or 'varchar(23)'
    %   -- Modifiers :- list of modifier atoms, such as not_null, default(X), fk(Dest).
    %
    % index(Name, Table, Columns)
    %   -- Name :- atom, name of this index
    %   -- Table :- atom, name of the table this index is on
    %   -- Columns :- list of atoms, column names
    
    % usage: 
    %   phrase_from_file(tokens(Toks), 'opt-create-table.sql'), phrase(tables(Tables), Toks).
    
    %declarations([T|Tables]) --> table(T), declarations(Tables).
    %declarations(Tables) --> index(I), declarations(Tables1), { insert_index(I, Tables1, Tables) }.
    
    %insert_index(Index, TableList, Result) :-
    
    objects([O|Rest]) --> object(O), [';'], objects(Rest).
    objects([]) --> [].
    
    object(O) --> table(O) ; index(O).
    
    index(index(Name, Table, Columns)) --> 
        [create, index, Name, on, Table, '('], identifiers(Columns), [')'].
        
    identifiers([I|Is]) --> [I, ','], identifiers(Is).
    identifiers([I]) --> [I].
    
    tables([T|Ts]) --> table(T), tables(Ts), !.
    tables([]) --> [].
    
    % parse a table definition
    table(table(Name, Columns)) --> [create,table,Name,'('], columns(Columns), [')'].
    
    % parse the list of column definitions
    columns([Column]) --> column(Column).
    columns([Column|Columns]) --> column(Column), [','], columns(Columns).
    
    % parse a column
    column(column(Name,Type,Modifiers)) --> [Name], type(Type), modifiers(Modifiers).
    
    % parse the modifiers (DEFAULT FOO NOT NULL etc.)
    modifiers([Mod|Modifiers]) --> modifier(Mod), modifiers(Modifiers).
    modifiers([]) --> [].
    
    % various modifiers
    modifier(not_null) --> [not, null].  
    modifier(default(X)) --> [default], literal(X).
    modifier(pk) --> [primary, key].
    modifier(fk(Dest)) --> [references,Dest].
    modifier(fk(Dest, Ids)) --> [references, Dest, '('], identifiers(Ids), [')'].
    modifier(unique) --> [unique].
    
    literal(X) --> [X], cast, type(_).
    literal(X) --> [X].
    
    cast --> [':',':'].
    
    % the type code
    type(Type) --> basic_type(Kind), range(Range), { Type =.. [Kind, Range] }.
    type(Type) --> basic_type(Type).
    
    % range/scale
    range(X) --> ['(', X, ')'].
    range(X-Y) --> ['(', X, ',', Y, ')'].
    
    % basic types 
    % I assume there are only one and two word type names in the DB, such as
    % 'character varying' and 'double precision', but this is just a kludge to
    % prevent spurious parses with types that contain modifiers
    basic_type(X) --> [X].
    basic_type(varchar) --> [character,varying].
    basic_type(timestamp) --> [timestamp,_,time,zone].
    basic_type(double_precision) --> [double,precision].

:- end_object.