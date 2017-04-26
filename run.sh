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
  # variables
  export GRADLE_PATH=gradle.properties   # path to the gradle file
  export GRADLE_FIELD="STABLE_VERSION"   # field name
  export VERSION_TMP=$(grep $GRADLE_FIELD $GRADLE_PATH | awk '{print $3}')    # get value versionName"0.1.0"
  export TAG=$(echo $VERSION_TMP | sed -e 's/^"//'  -e 's/"$//')  # remove quotes 0.1.0

  # Check if the tag already exists
  if [ $(git tag -l "$TAG") ]; then
    info "A tag for this version ($TAG) already exists"
  else
    info "Tagging commit '$WERCKER_GIT_COMMIT' with '$TAG'"
    # Tag and push commit
    git tag -a $TAG $WERCKER_GIT_COMMIT -m "$TAG"
    # List tags just to double check.
    git tag -l
    git push --tags $GIT_REMOTE
  fi
#else
  #info "---------------------"
  #info "Something went wrong with the previous step. Not going to tag just incase."
  #info "---------------------"
#fi
