%% Database structure (Example)
:- discontiguous(column/3, primary_key/2, unique/2, index/2, foreign_key/4).

%% Structure of the sample database:
%%
%% CREATE TABLE managers (id SERIAL PRIMARY KEY);
%%
%% CREATE TABLE users (
%%   id SERIAL PRIMARY KEY,
%%   name VARCHAR UNIQUE,
%%   manager_id INTEGER
%% );
%%
%% CREATE TABLE projects (
%%   id SERIAL PRIMARY KEY,
%%   user_id INTEGER REFERENCES users,
%%   tag1 VARCHAR,
%%   tag2 VARCHAR,
%%   tag3 VARCHAR,
%%   access1 VARCHAR,
%%   access2 VARCHAR
%% );
%%

column(managers, id, integer).
primary_key(managers, id).

column(users, id, integer).
column(users, name, varchar).
column(users, manager_id, integer).

primary_key(users, id).
unique(users, name).
index(users, id).

column(projects, id, integer).
column(projects, user_id, integer).
column(projects, tag1, varchar).
column(projects, tag2, varchar).
column(projects, tag3, varchar).
column(projects, access1, varchar).
column(projects, access2, varchar).

foreign_key(projects, user_id, users, id).
index(projects, id).
