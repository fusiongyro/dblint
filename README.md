### dblint

dblint examines a relational database and makes suggestions to improve
structure.

dblint's suggestions come from my experience as a relational database
user and DBA.

At the moment, more is unimplemented than implemented, but it is a
short example of the kinds of problems Prolog is good at solving. 

### Example Session

The sample database's structure looks something like this:

    CREATE TABLE managers (id SERIAL PRIMARY KEY);

    CREATE TABLE users (
      id SERIAL PRIMARY KEY,
      name VARCHAR UNIQUE,
      manager_id INTEGER
    );

    CREATE TABLE projects (
      id SERIAL PRIMARY KEY,
      user_id INTEGER REFERENCES users,
      tag1 VARCHAR,
      tag2 VARCHAR,
      tag3 VARCHAR,
      access1 VARCHAR,
      access2 VARCHAR
    );

This is an example suggestion session with the sample database loaded:

    $ swipl
    ?- ['dblint.pro'].
    true.
    
    ?- suggestion(Action, Reason).

    Action = remove_redundant_pk(users, id, name),
    Reason = 'Surrogate used in place of natural key' ;
    
    Action = extract_repeating_group(projects, access, [access1, access2]),
    Reason = 'Repeating group' ;
    
    Action = extract_repeating_group(projects, tag, [tag1, tag2, tag3]),
    Reason = 'Repeating group' ;
    
    Action = add_index(projects, user_id),
    Reason = 'Unindexed foreign key' ;
    
    Action = add_foreign_key(users, manager_id, managers, id),
    Reason = 'Missing foreign key' ;
    
    false.

So you can see that dblint correctly identified several types of
problems, including repeating groups, a redundant surrogate key, an
unindexed foreign key and a column that probably is a foreign key but
lacks the constraint.

### Future

In the future, dblint will be relatively database agnostic. It will
group recommendations into various categories, including style,
normalization and type suggestions. It will also generate SQL to
perform the changes it recommends.
