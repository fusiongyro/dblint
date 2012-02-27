:- protocol(suggestionp).

    :- info([
        version is 0.1,
        author is 'Daniel Lyons',
        date is 2012/02/27,
        comment is 'Represents a database improvement suggestion.',
        copyright is '© 2012 Daniel Lyons',
        license is 'BSD']).
    
    :- public(description/1).
    :- mode(description(?atom), one).
    :- info(description/1, [
        comment is 'Describes the suggestion.',
        argnames is ['Description']]).
    
    :- public(sql/1).
    :- mode(sql(?list), one).
    :- info(sql/1, [
        comment is 'SQL to implement the suggestion (list of atoms).',
        argnames is ['SQL']]).

:- end_protocol.