#!/bin/bash

# 1. Set the path to your repository
REPO_PATH="$HOME/space" # CHANGE THIS

# Navigate to the directory
cd "$REPO_PATH" || { echo "Repository not found"; exit 1; }

# 2. Check if there are any changes to commit
    git pull
if [[ -n $(git status -s) ]]; then
    # Add all changes
    git add .
    
    # Commit with the current timestamp
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
    git commit -m "Auto-commit: $TIMESTAMP"
    
    # Push to the remote repository (update 'main' if your branch is 'master')
    git push origin main
    
    echo "Successfully pushed at $TIMESTAMP"
else
    echo "No changes to push at $(date +'%Y-%m-%d %H:%M:%S')"
fi
