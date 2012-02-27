:- object(main).

    :- public(run_on_file/1).
    :- mode(run_on_file(+atom), one).
    run_on_file(Filename) :-
        schema::from_file(Filename, Schema),
        all_patterns(Patterns),
        meta::map([Pattern]>>(try_pattern(Schema, Pattern)), Patterns).
        
    all_patterns(Patterns) :-
        setof(Pattern, implements_protocol(Pattern, patternp), Patterns).

    try_pattern(Schema, Pattern) :-
        setof(Suggestion, Pattern::detect(Schema, Suggestion), Suggestions),
        meta::map([Suggestion]>>(inform_suggestion(Suggestion)), Suggestions).
    
    inform_suggestion(Suggestion) :-
        Suggestion::description(Description),
        Suggestion::sql(SQL),
        write(Description), nl,
        write('  '), write(SQL), nl.

:- end_object.