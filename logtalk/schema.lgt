:- object(schema, implements(schemap)).

    :- dynamic([column/3, primary_key/2, unique/2, foreign_key/4, index/2]).
    
    :- public(from/1).
    :- mode(from(+list), zero_or_one).
    
    from(SQL) :-
        tokenizer::tokenize(SQL, Tokens),
        parser::objects(Tokens, Objects), !,
        process_objects(Objects).
    
    :- private(process_objects/1).
    
    process_objects([Object|Objects]) :- 
        process_object(Object), process_objects(Objects).
    process_objects([]).
    
    process_object(index(Table, Columns)) :-
        asserta(index(Table, Columns)).
    process_object(_).

:- end_object.