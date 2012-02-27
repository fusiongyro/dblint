:- object(util).

    :- public(atom_concat/2).
    :- mode(atom_concat(+list_of_atoms, -atom), one).
    :- info(atom_concat/2, [
        comment is 'Concatenates all the atoms in List into Atom',
        argnames is ['AtomList', 'Atom']]).
    
    atom_concat(AtomList, Atom) :- 
        meta::fold_right(atom_concat, '', AtomList, Atom).

    :- public(pluralize/2).
    :- mode(pluralize(+atom, -atom), one).
    :- info(pluralize/2, [
        comment is 'Succeeds if Plural is the plural form of Singular',
        argnames is ['Singular', 'Plural']]).
    
    pluralize(Singular, Plural) :- irregular_plural(Singular, Plural), !.
    pluralize(Iris, Irises) :-
        atom_concat(Iris, es, Irises), 
        atom_concat(_, s, Iris), !.
    pluralize(Cow, Cows) :-
        atom_concat(Cow, s, Cows).

    %% Basic irregular noun database below derived from page at
    %% http://english-zone.com/spelling/plurals.html

    irregular_plural(child, children).
    irregular_plural(man, men).
    irregular_plural(woman, women).
    irregular_plural(ox, oxen).
    
    irregular_plural(bacterium, bacteria).
    irregular_plural(corpus, corpora).
    irregular_plural(criterion, criteria).
    irregular_plural(datum, data).
    irregular_plural(genus, genera).
    irregular_plural(medium, media).
    irregular_plural(memorandum, memoranda).
    irregular_plural(phenomenon, phenomena).
    irregular_plural(stratum, strata).
    
    irregular_plural(foot, feet).
    irregular_plural(goose, geese).
    irregular_plural(tooth, teeth).

    irregular_plural(Alumnus, Alumni) :-
        list::member(Alumnus, [alumnus, cactus, focus, fungus, nucleus, 
                               radius, stimulus]), !,
        atom_concat(Alumn, us, Alumnus), atom_concat(Alumn, i, Alumni).
    irregular_plural(Axis, Axes) :-
        list::member(Axis, [axis, analysis, basis, crisis, diagnosis, 
                              ellipsis, hypothesis, oasis, paralysis, 
                              parenthesis, synthesis, synopsis, thesis]), !,
        atom_concat(Ax, is, Axis), atom_concat(Ax, es, Axes).
    irregular_plural(Matrix, Matrices) :-
        list::member(Matrix, [appendix, matrix]), !,
        atom_concat(Matr, ix, Matrix), atom_concat(Matr, ices, Matrices).
    irregular_plural(Bureau, Bureaux) :-
        list::member(Bureau, [beau, bureau, tableau]), !,
        atom_concat(Bureau, x, Bureaux).
    irregular_plural(Deer, Deer) :-
        list::member(Deer, [deer, fish, means, offspring, series, sheep, 
                            species]), !.
    irrelugal_plural(Antenna, Antennae) :-
        list::member(Antenna, [antenna, formula, nebula, vertebra, vita]), !,
        atom_concat(Antenna, e, Antennae).
    irregular_plural(Mouse, Mice) :-
        list::member(Mouse, [louse, mouse]), 
        atom_concat(Mouse, ouse, M), atom_concat(M, ice, Mice).    

:- end_object.