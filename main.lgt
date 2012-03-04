:- object(main).

    :- info([
        comment is 'The main entrypoint for this application.',
        author is 'Daniel Lyons']).

    :- public(run_on_file/1).
    :- mode(run_on_file(+atom), one).
    :- info(run_on_file/1, [
        comment is 'Run the analysis on a file with SQL DDL in it.']).
    run_on_file(Filename) :-
        schema::from_file(Filename, Schema),
        all_patterns(Patterns),
        meta::map([Pattern]>>(try_pattern(Schema, Pattern)), Patterns).
    
    %% Unifies Patterns with every patternp instance.
    all_patterns(Patterns) :-
        setof(Pattern, implements_protocol(Pattern, patternp), Patterns).

    %% Apply Schema to Pattern and process each suggestion.
    try_pattern(Schema, Pattern) :-
        setof(Suggestion, Pattern::detect(Schema, Suggestion), Suggestions),
        meta::map([Suggestion]>>(inform_suggestion(Suggestion)), Suggestions).
    
    %% Display the suggestion to the user: show the descirption and the SQL
    inform_suggestion(Suggestion) :-
        Suggestion::description(Description),
        Suggestion::sql(SQL),
        write(Description), nl,
        write('  '), write(SQL), nl.

:- end_object.