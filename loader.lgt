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
        missing_foreign_key_index,
        repeating_groups,
        unnecessary_surrogate_key,
        missing_foreign_key]))).