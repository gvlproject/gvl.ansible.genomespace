#!/bin/bash
SOURCE="${BASH_SOURCE[0]}"
DIR="$( dirname "$SOURCE" )"
libjar="$DIR/secretkeygenerator-0.0.1-SNAPSHOT.jar"
if test "$1" == "" ; then
    outFile="genomespace-secret.key"
else
    outFile="$1"
fi
java -jar "$libjar" "$outFile"
exitCode=$?
if [ $exitCode -eq 0 ]; then
    echo "GenomeSpace secret key saved in file $outFile"
else
    echo "GenomeSpace secret key generation failed"
fi
