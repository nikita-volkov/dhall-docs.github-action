#!/bin/bash -e

echo name=output::"$(dhall-docs --input $input)" >> $GITHUB_OUTPUT
