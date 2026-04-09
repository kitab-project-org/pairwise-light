#!/bin/bash

# This script copies the light reuse data from the passim folder,
# adds, commits and pushes it in batches,
# then adds a version tag.

# set the passim run ID
openiti_release="2025.1.9"
passim_run="${openiti_release}-pri"


# Set the path to the folders:
orig_folder="/home/admin-kitab/Documents/passim_runs/kitab_runs/2025/master/v9/pri/output/align_align-stats_bi-dir_light.csv"
data_folder="/home/admin-kitab/Documents/passim_runs/all_pairwise_light_github/pairwise-light/data/"

# copy the light data from the folder where it was created:
echo "cp -r $orig_folder/* $data_folder"
echo "COPYING THE DATA FROM THE PASSIM FOLDER (this will take some time)"
cp -r "$orig_folder"/* "$data_folder"

# read the GitHub token:
ghtoken=`cat ./GHtoken.txt`
#echo "$ghtoken"
#echo "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git"

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
  echo "git commit with message add data $passim_run batch $batch_no"
  git commit -m "add data $passim_run batch $batch_no" --quiet
  echo "git push"
  git push "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git"
  ((batch_no++))
done

# add the tag: 
echo "Create new tag: v$passim_run and push it to GitHub:"
git tag -a "v$passim_run" -m "pairwise passim run, primary texts only, OpenITI release $openiti_release"
git push "https://oauth:$ghtoken@github.com/kitab-project-org/pairwise-light.git" --tags
