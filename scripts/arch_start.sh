#!/bin/bash

# Name of the tmux session
SESSION_NAME="server"

# Check if the session already exists
tmux has-session -t $SESSION_NAME 2>/dev/null

if [ $? -ne 0 ]; then
  # 1. Create the session and the first window (named "jianghu"), but don't attach yet
  tmux new-session -d -s $SESSION_NAME -n "jianghu"

  # 2. Run a command in the first window
  # (Using 'C-m' at the end simulates pressing Enter)
  tmux send-keys -t $SESSION_NAME:"jianghu" "cd \$HOME/projects/jianghu/docker && docker compose up -d && cd .. && air" C-m

  # 3. Create the second window (named "silver")
  tmux new-window -t $SESSION_NAME -n "silver"
  tmux send-keys -t $SESSION_NAME:"silver" "cd \$HOME/projects/silverbullet && air" C-m

  tmux new-window -t $SESSION_NAME -n "goclaw"
  tmux send-keys -t $SESSION_NAME:"goclaw" "goclaw" C-m

  tmux new-window -t $SESSION_NAME -n "9router"
  tmux send-keys -t $SESSION_NAME:"9router" "9router" C-m
  
  # Optional: Ensure it starts focused on the first window
  tmux select-window -t $SESSION_NAME:"jianghu"
fi

