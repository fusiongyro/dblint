:- ['suggestions.pro'].

suggestion_sql(remove_redundant_pk(Table, OldId, NewId),
	      [drop_primary_key(Table, OldId),
	       add_primary_key(Table, NewId),
	       drop_column(Table, OldId)]).

% this SQL generator should
% - create a new table with the name old-table_prefixes
%   - column for ID
%   - column for FK to old table
%   - column for value
% - foreign key to old table
% - drop columns on old table
%suggestion_sql(extract_repeating_group(Table, Prefix, Columns),
%	       [create_table(NewTableName, [column(

suggestion_sql(add_index(Table, Column),
	      [add_index(Table, Column)]).

suggestion_sql(add_foreign_key(Destination, FK, Source, PK),
	      [add_foreign_key(Destination, FK, Source, PK)]).

