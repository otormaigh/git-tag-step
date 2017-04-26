if [ ! -d ".git" ]; then
  fail "There aint no git here"
elif [ ! -n "$WERCKER_GIT_TAG_BRANCH" ]; then
  fail 'Missing branch property'
fi

#if [ "$WERCKER_RESULT" = "success" ]; then
  # Configure git user
  git config --global user.email elliot@tapadoo.com
  git config --global user.name "Elliot Tormey"

  # Get list of tags from repo
  # info "GIT_REMOTE = $GIT_REMOTE"
  # git fetch --tag $GIT_REMOTE

  # Set the tag name to the stable version of the release
  tagname="$STABLE_VERSION"

  # Check if the tag already exists
  if [ $(git tag -l "$tagname") ]; then
    info "A tag for this version ($tagname) already exists"
  else
    info "Tagging commit $WERCKER_GIT_COMMIT"
    # Tag and push commit
    git tag -a tagname $WERCKER_GIT_COMMIT -m "$tagname"
    git push --tags $GIT_REMOTE
  fi
#else
  #info "---------------------"
  #info "Something went wrong with the previous step. Not going to tag just incase."
  #info "---------------------"
#fi
