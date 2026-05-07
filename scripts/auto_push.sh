#!/bin/bash

# 1. Define an array of paths to your repositories
REPO_PATHS=(
    "$HOME/projects/space"
    "$HOME/dotfiles"
)

# Iterate through each folder in the list
for REPO in "${REPO_PATHS[@]}"; do
    echo "--------------------------------------"
    echo "Processing: $REPO"
    
    # Navigate to the directory
    if cd "$REPO"; then
        # 2. Check if there are any changes to commit
        git pull
        
        if [[ -n $(git status -s) ]]; then
            # Add all changes
            git add .

            # Commit with current timestamp
            TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
            git commit -m "Auto-commit: $TIMESTAMP"

            # Push to remote (adjust 'main' or 'master' as needed)
            git push origin main
            
            echo "Successfully pushed $REPO at $TIMESTAMP"
        else
            echo "No changes to push in $REPO"
        fi
    else
        echo "Error: Directory $REPO not found. Skipping..."
    fi
done

echo "--------------------------------------"
echo "All repositories processed."
