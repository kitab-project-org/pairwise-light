#!/bin/bash

# Set the path to your main folder
main_folder="/home/admin-kitab/Documents/passim_runs/all_pairwise_light_github/pairwise-light"

# set the passim run ID
passim_run="2023.1.8"

# read the GitHub token:
ghtoken=`cat ./GHtoken.txt`
#echo "$ghtoken"
#echo "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git"

# Change directory to the main folder
cd "$main_folder" || exit

# remove all data in the data folder:
echo "Removing all data subfolders"
rm -rf data/*/

# group folders into manageable size batches:
patterns=(
  "data/[A-H]*"
  "data/[I-J]*"
  "data/[K-R]*"
  "data/Shamela*"
  "data/S*"
  "data/[T-Z]*"
)


# iterate over batches:

batch_no=1

for pattern in "${patterns[@]}"; do
  echo "BATCH NO $batch_no"
  echo "git add $pattern"
  git add $pattern
  echo "git commit with message rm data $passim_run batch $batch_no"
  git commit -m "rm data $passim_run batch $batch_no" --quiet
  echo "git push"
  git push "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git"
  ((batch_no++))
done

