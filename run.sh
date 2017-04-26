if [ ! -d ".git" ]; then
  fail "There aint no git here"
elif [ ! -n "$WERCKER_GIT_TAG_BRANCH" ]; then
  fail 'Missing branch property'
fi

#if [ "$WERCKER_RESULT" = "success" ]; then
  cd $WERCKER_SOURCE_DIR
  # Configure git user
  git config user.email elliot@tapadoo.com
  git config user.name "Elliot Tormey"

  # Set the tag to the stable version of the release
  tag = $(gradle -q printVersion)

  # Check if the tag already exists
  if [ $(git tag -l "$tag") ]; then
    info "A tag for this version ($tagname) already exists"
  else
    info "Tagging commit '$WERCKER_GIT_COMMIT' with '$tag'"
    # Tag and push commit
    git tag -a $tag $WERCKER_GIT_COMMIT -m "$tag"
    # List tags just to double check.
    git tag -l
    git push --tags $GIT_REMOTE
  fi
#else
  #info "---------------------"
  #info "Something went wrong with the previous step. Not going to tag just incase."
  #info "---------------------"
#fi
