#!/bin/bash -e

echo name=output::"$(dhall-docs --input $dir)" >> $GITHUB_OUTPUT
