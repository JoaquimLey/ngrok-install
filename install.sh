#!/usr/bin/env bash

#result=${sed -i "s/<add_your_token_here>/$1/g" ngrok.yml}

sed -i "s/<add_your_token_here>/$1/g" ngrok.yml
cat ngrok.yml