function extract
    if test -z "$argv"
        # Display help if no argument is given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    else
        if test -f "$argv"
            switch $argv
                case '*.tar.bz2'
                    tar xvjf $argv
                case '*.tar.gz'
                    tar xvzf $argv
                case '*.tar.xz'
                    tar xvJf $argv
                case '*.bz2'
                    bunzip2 $argv
                case '*.rar'
                    unrar x $argv
                case '*.gz'
                    gunzip $argv
                case '*.tar'
                    tar xvf $argv
                case '*.tbz2'
                    tar xvjf $argv
                case '*.tgz'
                    tar xvzf $argv
                case '*.zip'
                    unzip $argv
                case '*.Z'
                    uncompress $argv
                case '*.7z'
                    7z x $argv
                case '*.xz'
                    unxz $argv
                case '*'
                    echo "extract: '$argv' - unknown archive method"
            end
        else
            echo "$argv - file does not exist"
        end
    end
end
