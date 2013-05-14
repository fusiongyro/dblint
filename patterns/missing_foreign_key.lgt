:- object(missing_foreign_key, implements(patternp)).

    %% True if FK is a foreign key to the Source table
    foreign_key_name(Source, FK) :-
        nonvar(Source), !,
        pluralize(SourceCol, Source),
        atom_concat(SourceCol, '_id', FK).
    foreign_key_name(Source, FK) :-
        nonvar(FK), !,
        atom_concat(SourceCol, '_id', FK),
        pluralize(SourceCol, Source).

    %% True if Destination table's column FK looks like a foreign key to
    %% Source table's PK.
    detect(Schema, missing_foreign_key(Destination, [FK], Source, [id])) :-
        Schema::column(Destination, FK, _),
        foreign_key_name(Source, FK),
        Schema::column(Source, id, _),
        \+ Schema::foreign_key(Destination, FK, Source, _).

    pluralize(Noun, Nouns) :- atom_concat(Noun, 's', Nouns).

:- end_object.

:- object(missing_foreign_key(_Destination, _FK, _Source, _PK), implements(suggestionp)).

    destination(Destination) :- parameter(1, Destination).
    fk(FK)                   :- parameter(2, FK).
    source(Source)           :- parameter(3, Source).
    pk(PK)                   :- parameter(4, PK).
    
    description(Desc) :-
        destination(Dest), fk(FK), source(Source),
        parser::identifiers(FK, FKColumns), util::atom_concat(FKColumns, FKS),
        util::atom_concat(['Missing foreign key from ', Dest, ' (', FKS, ')', ' to ', Source], Desc).
        
    sql(SQL) :-
        destination(Destination), fk(FK), source(Source), pk(PK),
        util::atom_concat([Destination, '_', Source, '_fk'], FKName),
        parser::identifiers(FK, FKColumns), parser::identifiers(PK, PKColumns),
        list::append([[alter,table,Destination,add,constraint,FKName,foreign,key,'('],FKColumns,[')',references,Source,'('], PKColumns, [')',';']], SQL).

:- end_object.
