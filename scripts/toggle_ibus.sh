#!/bin/bash

# Define your two engines here
ENGINE1="BambooUs"   # English (US)
ENGINE2="Bamboo"          # Vietnamese 

# Get current engine
CURRENT=$(ibus engine)

# Toggle logic
if [ "$CURRENT" = "$ENGINE1" ]; then
    ibus engine "$ENGINE2"
    echo "Switched to: $ENGINE2"
else
    ibus engine "$ENGINE1"
    echo "Switched to: $ENGINE1"
fi

