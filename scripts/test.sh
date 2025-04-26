#!/bin/bash

hello_world () {
  echo "Hello world"  
}

list=(
  hello_world

)


for app in ${list[@]}; do
  $app
done
