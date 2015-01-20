#!/bin/bash

# Exits bash immediately if any command fails
set -e

# Will output commands as the run
set -x

# Want to know what ENV varibles Buildkite sets during the build?
env | grep BUILDBOX

# Buildkite will run your builds by default in:
# ~/.buildbox/account-name/project-name
# pwd

# Here are some basic setup instructions for checkout out a git repository.
# You have to manage checking out and updating the repo yourself.

# If the git repo doesn't exist in the b
if [ ! -d ".git" ]; then
    git clone "$BUILDBOX_REPO" . -q
fi

# Always start with a clean repo
git clean -fd

# Fetch the latest commits from origin, and checkout to the commit being tested
git fetch -q
git checkout -qf "$BUILDBOX_COMMIT"

git submodule init
git submodule update

set -o pipefail && xcrun xcodebuild -workspace BuildkiteKit.xcworkspace -scheme BuildkiteKit -sdk iphonesimulator8.2 -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.2' clean build test
