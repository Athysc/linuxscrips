function task_count
    set -l count (task status:pending +READY count 2>/dev/null)
    if test $count -gt 0
        set_color red
        echo " [$count tasks]"
        set_color normal
    end
end
