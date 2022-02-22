#!/bin/bash

while true;
do
  curl "$API_HOST:$API_PORT/docs" || (echo request to "$API_HOST:$API_PORT/docs" failed && false)
  if [ $? -eq 0 ]; then
    break
  fi
  docker compose logs
  sleep 2
done