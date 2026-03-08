function aws-select --description 'Switch AWS profile via fzf'
    set -l profile (cat ~/.aws/credentials ~/.aws/config | grep -E '^\[' | sed -E 's/\[|\]|\[profile //g' | sort -u | fzf)
    test -n "$profile" && set -gx AWS_PROFILE $profile
end
