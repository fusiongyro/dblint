:- object(tokenizer).
    
    :- public(tokenize/2).
    :- mode(tokenize(+list, -list), zero_or_one).
    tokenize(Codes, Tokens) :- phrase(tokens(Tokens), Codes).

    % private stuff
    
    tokens([T|Rest]) --> token(T), tokens(Rest).
    tokens([]) --> skip_junk.
    
    token(T) --> skip_junk, prim_token(T).
    
    %% skip handles both whitespace and comments
    skip_junk --> "--", skip_to("\n"), !, skip_junk.
    skip_junk --> "/*", skip_to("*/"), !, skip_junk.
    skip_junk --> whitespace, !, skip_junk.
    skip_junk --> [].
    
    % jump over intervening stuff until matching the sequence (and tossing it)
    skip_to(Sequence) --> Sequence.
    skip_to(Sequence) --> [_], skip_to(Sequence).
    
    % jump over whitespace
    whitespace --> [X], { char_type(X, space) }, !.
    
    % a primitive token: one of these five types
    prim_token(T) --> quoted(T) ; string(T) ; bare(T) ; punct(T) ; num(T).
    
    % a quoted identifier
    quoted(T) --> "\"", not_chars("\"", X), "\"", !, {atom_codes(T, X)}.
    
    % a string
    string(s(T)) --> "'", string_chars(Chars), "'", { atom_chars(T, Chars) }.
    
    % a bare identifier (lowercased automatically)
    bare(T) --> lower_char([alpha], X), idents(Xs), !, { atom_codes(T, [X|Xs]) }.
    
    % a piece of punctuation (probably relevant at higher level)
    punct(T) --> char([punct], P), { \+ member(P, "'\"") , atom_codes(T, [P]) }.
    
    % an integer literal
    num(T) --> 
        char([digit], D), 
        chars([digit], Ds), !, 
        { number_codes(T, [D|Ds]) }.
    
    % building block: capture all the characters that aren't in Chars into a list.
    not_chars(Chars, [X|Xs]) --> 
        [X], 
        { member(C, Chars), X \= C }, 
        not_chars(Chars, Xs).
    not_chars(_, []) --> [].
    
    % inside strings: any string characters
    string_chars([X|Xs]) --> string_char(X), string_chars(Xs), !.
    string_chars([]) --> [].
    
    % string characters: handle escaped single quotes (doubled)
    string_char(39) --> "''".
    string_char(X) --> [X], { [X] \= "'" }.
    
    % read a character in the list of types and lowercase it automatically
    lower_char(Types, X) --> 
        [Y], 
        {   member(Type, Types), 
            char_type(Y, Type), 
            char_type(Lowered, to_lower(Y)), 
            atom_codes(Lowered, [X])    }.
    
    % identifier characters
    idents([X|Xs]) --> ident(X), idents(Xs).
    idents([]) --> [].
    
    % an identifier is any alphanumeric character or underscore
    ident(X) --> lower_char([alnum], X).
    ident(95) --> "_".
    
    % primitive: read a list of characters of the supplied types
    chars(Types, [X|Xs]) --> char(Types, X), chars(Types, Xs).
    chars(_, []) --> [].
    
    % primitive: read a character belonging to the supplied type
    char(Types, X) --> [X], { member(Type, Types), char_type(X, Type) }.
    
    member(X, [X|_]).
    member(X, [_|Xs]) :- member(X, Xs).
    
:- end_object.