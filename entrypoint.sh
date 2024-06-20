#!/bin/bash
#just a simple echo statement for the sake of entrypoint
echo "Hello to the induction server. Please find the required files in your directory."
#Replace current shell procees with what the cotainer is running 
exec "$@"
