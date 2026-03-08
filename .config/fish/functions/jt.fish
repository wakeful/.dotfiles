function jt --description 'Jump to git repository root'
    cd (git rev-parse --show-toplevel)
end
