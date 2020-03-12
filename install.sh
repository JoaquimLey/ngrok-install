#!/usr/bin/env bash

#result=${sed -i "s/<add_your_token_here>/$1/g" ngrok.yml}

echo(${sed -i "s/<add_your_token_here>/$1/g" ngrok.yml}
echo(${sed -i "s/<<us|eu|ap|au>/$2/g" ngrok.yml}