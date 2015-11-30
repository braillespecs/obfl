#!/bin/bash

if [ "$TRAVIS_REPO_SLUG" == "joeha480/obfl" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then

  echo -e "Publishing...\n"

  cp -R build/site $HOME

  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "travis-ci"
  git clone --quiet https://${GH_TOKEN}@github.com/joeha480/joeha480.github.io  > /dev/null

  cd joeha480.github.io
  git rm -rf ./obfl
  cp -Rf $HOME/site ./obfl
  git add -f .
  git commit -m "Lastest successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to master"
  git push -fq origin master > /dev/null

  echo -e "Published site to joeha480.github.io/obfl.\n"
  
fi
