#!/bin/bash

# Set the path to your main folder
main_folder="/home/admin-kitab/Documents/passim_runs/all_pairwise_light_github/pairwise-light/data"

# set the passim run ID
passim_run="2023.1.8-pri"

# read the GitHub token:
ghtoken=`cat ./GHtoken.txt`
echo "$ghtoken"
echo "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git"


# Set the desired commit size in bytes (1 GB = 1073741824 bytes)
commit_size=250000000

# Change directory to the main folder
cd "$main_folder" || exit

# Function to get the size of a folder in bytes
# NB: "cut -f1" takes the first column of du's output
get_folder_size() {
    du -bs "$1" | cut -f1
}

# Function to commit changes
commit_changes() {
    echo "Removing data from $passim_run (batch)"
    git commit -m "Removing data from $passim_run (batch)"
    git push "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git"
}

# Iterate over subfolders
total_size=0
all_folders_size=0
for subfolder in */; do
    size=$(get_folder_size "$subfolder")
    #echo "$subfolder : $size"
    total_size=$((total_size + size))
    all_folders_size=$((all_folders_size + size))
    #echo $((total_size))
    # remove the subfolder and add to git:
    rm -rf "$subfolder"
    git add "$subfolder"

    # Check if the total size exceeds the commit size
    if [ "$total_size" -ge "$commit_size" ]; then
        echo "Total size: $total_size"
        commit_changes
        total_size=0
    fi
done

# Commit any remaining changes
commit_changes
echo "All folders size: $all_folders_size"
