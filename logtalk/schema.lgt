:- object(metaschema,
    instantiates(metaschema)).
    
    :- public(new/2).
    :- mode(new(+string, -object_identifier), one).
    :- info(new/2, [
        comment is 'Creates a new schema from some SQL',
        argnames is ['SQL', 'Schema']]).
    
    new(SQL, Schema) :-
        self(Self),
        create_object(Schema, [instantiates(Self)], [], []),
        Schema::parse(SQL).
        
:- end_object.

:- object(schema,
    instantiates(metaschema),
    implements(schemap)).
    
    %:- dynamic([column/3, primary_key/2, unique/2, foreign_key/4, index/2]).
    
    :- public(parse/1).
    :- mode(parse(+string), zero_or_one).
    
    parse(SQL) :-
        tokenizer::tokenize(SQL, Tokens),
        parser::objects(Tokens, Objects),
        ::process_objects(Objects), !.
        
    process_objects([Object|Objects]) :- 
        process_object(Object), process_objects(Objects), !.
    process_objects([]).
    
    process_object(index(Table, Columns)) :-
        ::asserta(index(Table, Columns)), !.
    process_object(_).

:- end_object.