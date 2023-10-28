#!/bin/bash

#######################################
# moves and renames a file in a directory
# Arguments:
#   1
#   2
#   3
#######################################
function create_directory() {
    local dir_name=$1
    local file_dir=$2
    new_dir_path="$file_dir/$dir_name"  # This creates or updates the global new_dir_path

    # Create the directory
    if ! mkdir -p "$new_dir_path"
    then
        echo "Error: Could not create directory $new_dir_path"
        exit 1
    fi

    echo "Directory created: $new_dir_path"
}

# Function to move and rename the file
function move_and_rename_file() {
    local filepath=$1
    local new_name=$2
    local extension=$3
    local new_file_name="$new_name$extension"
    local new_file_path="$new_dir_path/$new_file_name"

    # Move and rename the file
    if ! mv "$filepath" "$new_file_path"
    then
        echo "Error: Could not move and rename the file."
        exit 1
    fi

    echo "File moved and renamed: $new_file_path"
}

# Function to extract name and year from filename
function extract_info() {
    local filepath=$1
    local filename
    filename=$(basename "$filepath")
    local dirname
    dirname=$(dirname "$filepath")
    local extension=${filename: -4}

    # Remove the extension from filename for processing
    filename=${filename%.*}
    local i
    local char
    local name
    local year

    for (( i=0; i<${#filename}; i++ )); do
        char=${filename:i:1}
        if [[ $char =~ [0-9] ]]; then
            # Found the first numeric character
            name=${filename:0:i}
            year=${filename:i:4}
            break
        fi
    done

    if [[ -z $name || -z $year ]]; then
        echo "Error: Filename does not conform to the expected format."
        exit 1
    fi

    # Replace dots with spaces in the name
    name=${name//./ }

    local dir_name="${name}(${year})"
    create_directory "$dir_name" "$dirname"

    move_and_rename_file "$filepath" "$name" "$extension"
}


#######################################
# Takes exactly one argument that is either a directory or a file name
# Arguments:
#   1
#######################################
function main() {
  # Check if filename parameter is provided
if [[ -z $1 ]]; then
    echo "Usage: $0 <filename>"
    exit 1
fi
    extract_info "$1"
}

main "$@"
