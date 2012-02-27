:- object(suggestion(_Description, _SQL), implements(suggestionp)).

    :- public(description/1).
    :- mode(description(?atom), one).
    
    :- public(sql/1).
    :- mode(sql(?list), one).
    
    description(Desc) :-
        parameter(1, Description).
        
    sql(SQL) :-
        parameter(2, SQL).

:- end_object.