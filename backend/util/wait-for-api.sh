#!/bin/bash

while true;
do
  curl "$API_HOST:$API_PORT/docs" || (echo request to "$API_HOST:$API_PORT/docs" failed && false)
  if [ $? -eq 0 ]; then
    echo backend ready
    break
  fi
done