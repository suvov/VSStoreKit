#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

jazzy \
    --clean \
    --author 'Vladimir Shutyuk' \
    --author_url 'https://twitter.com/suvov' \
    --github_url 'https://github.com/suvov/VSStoreKit' \
    --module 'VSStoreKit' \
    --source-directory . \
    --readme 'README.md' \
    --output docs/ \
