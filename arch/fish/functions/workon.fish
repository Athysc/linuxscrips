function workon --description 'Create or activate a python venv in /mnt/AppData/pythonenvs'
    # 1. Set the base directory for your environments
    set -l venv_base /mnt/AppData/pythonenvs

    # 2. Check if an argument (environment name) was provided
    if test (count $argv) -eq 0
        echo "Available environments in $venv_base:"
        ls $venv_base
        return 1
    end

    set -l venv_name $argv[1]
    set -l target_path "$venv_base/$venv_name"

    # 3. Check if the directory exists. If not, create the venv.
    if not test -d "$target_path"
        echo "Environment '$venv_name' not found. Creating it..."
        python -m venv "$target_path"

        if test $status -eq 0
            echo "Successfully created '$venv_name'."
        else
            echo "Error creating environment."
            return 1
        end
    end

    # 4. Activate the environment
    # Fish uses activate.fish, which is standard in venvs created by python -m venv
    if test -f "$target_path/bin/activate.fish"
        source "$target_path/bin/activate.fish"
        echo "Activated '$venv_name'."
    else
        echo "Error: Could not find activation script at $target_path/bin/activate.fish"
        return 1
    end
end
