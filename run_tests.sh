#!/bin/sh

for F in build/tests/*; do
    ./$F
done
