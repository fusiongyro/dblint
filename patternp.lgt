:- protocol(patternp).

    :- info([
        comment is 'Defines a particular pattern of misbehavior in a schema, and returns suggested improvements.']).    

    :- public(detect/2).
    :- mode(detect(+schema_instance, -suggestion_instance), zero_or_more).
    :- info(detect/2, [
        comment is 'Detects suggestions for the supplied Schema.',
        argnames is ['Schema', 'Suggestion']]).

:- end_protocol.