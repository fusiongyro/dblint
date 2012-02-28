### dblint

dblint examines a relational database and makes suggestions to improve
structure.

dblint's suggestions come from my experience as a relational database
user and DBA.

At the moment, more is unimplemented than implemented, but it is a
short example of the kinds of problems Prolog is good at solving. 

### Example Session

The sample database's structure is in basic.sql and looks something like this:

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

This is an example suggestion session:

    $ swilgt
    ?- [loader].
    true.
    
    ?- main::run_on_file('basic.sql').
    Missing foreign key from projects (user_id) to users
    
      [alter,table,projects,add,constraint,projects_users_fk,foreign,key, (,user_id,),references,users, (,id,),;]
      
    Missing foreign key from users (manager_id) to managers
    
      [alter,table,users,add,constraint,users_managers_fk,foreign,key, (,manager_id,),references,managers, (,id,),;]
      
    Unindexed foreign key on projects (user_id)
    
      [create,index,on,projects, (,user_id,)]
      
    Repeating group on projects with name access
    
      [begin,;,create,table,projects_accesses, (,),;,;,;,commit,;]
      
    Repeating group on projects with name tag
    
      [begin,;,create,table,projects_tags, (,),;,;,;,commit,;]
      
    Unnecessary surrogate key on users (use name instead)
    
      [alter,table,users,drop,column,id,,,add,primary,key, (,name,),;]

    true.
    

So you can see that dblint correctly identified several types of
problems, including repeating groups, a redundant surrogate key, an
unindexed foreign key and a column that probably is a foreign key but
lacks the constraint, and it even attempted to output SQL to correct it.

### Future

My goal is to improve dblints suggestions. I don't mind staying relatively PostgreSQL specific, at least in terms of advice; I would like to be able to parse MySQL and others SQL even if I'm assuming that PostgreSQL is the actual target. I would like to ensure that the generated SQL takes into account earlier suggestions and can be configured to display particular categories of suggestion, such as style, normalization, etc.