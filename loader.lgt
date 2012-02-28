:- initialization((
    % SWI library
    [library(pio)],
    
    % Logtalk libraries
    logtalk_load([
        library(meta_compiler_loader), 
        library(types_loader)]),
        
    % basis
    logtalk_load([
        tokenizer, 
        parser, 
        schemap, 
        schema, 
        patternp, 
        suggestionp,
        util,
        main]),
        
    % patterns
    logtalk_load([
        patterns(missing_foreign_key_index),
        patterns(repeating_groups),
        patterns(unnecessary_surrogate_key),
        patterns(missing_foreign_key),
        patterns(missing_schema)]))).