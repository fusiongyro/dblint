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

tables([T|Ts]) --> table(T), tables(Ts), !.
tables([]) --> [].

% parse a table definition
table(table(Name, Columns)) --> [create,table,Name,'('], columns(Columns), [')', ';'].

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
basic_type(timestamp) --> [timestamp,X,time,zone].
basic_type(double_precision) --> [double,precision].