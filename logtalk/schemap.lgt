:- protocol(schemap).

    :- info([
        version is 0.1,
        author is 'Daniel Lyons',
        date is 2012/02/25,
        comment is 'Represents a complete database schema.',
        copyright is '© 2012 Daniel Lyons',
        license is 'BSD']).
    
    :- dynamic([column/3, primary_key/2, unique/2, foreign_key/4, index/2]).
    
    :- public(column/3).
    :- mode(column(?atom, ?atom, ?atom), zero_or_more).
    :- info(column/3, [
        comment is 'Succeeds if ColumnName is a column on table Table with type Type.',
        argnames is ['Table', 'ColumnName', 'Type']]).
        
    :- public(primary_key/2).
    :- mode(primary_key(?atom, ?list), zero_or_more).
    :- info(primary_key/2, [
        comment is 'Succeeds if Keys is a list of key columns on table Table',
        argnames is ['Table', 'Keys']]).

    :- public(unique/2).
    :- mode(unique(?atom, ?list), zero_or_more).
    :- info(unique/2, [
        comment is 'Succeeds if Keys are a list of together-unique columns on Table.',
        argnames is ['Table', 'Keys']]).
    
    :- public(foreign_key/4).
    :- mode(foreign_key(?atom, ?list, ?atom, ?list), zero_or_more).
    :- info(foreign_key/4, [
        comment is 'Succeeds if SourceKeys on SourceTable are a foreign key which references DestKeys on DestTable',
        argnames is ['SourceTable', 'SourceKeys', 'DestTable', 'DestKeys']]).

    :- public(index/2).
    :- mode(index(?atom, ?list), zero_or_more).
    :- info(index/2, [
        comment is 'Succeeds if Table has an index on Columns.',
        argnames is ['Table', 'Columns']]).

:- end_protocol.