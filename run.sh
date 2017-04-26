if [! -d ".git"]; then
  fail "There aint no git here"
fi

# Configure git user
if ["$WERCKER_RESULT" = "passed"]; then
  git config --global user.email elliot@tapadoo.com
  git config --global user.name "Elliot Tormey"

  # Get list of tags from repo
  git fetch --tage $GIT_REMOTE

  # Set the tag name to the stable version of the release
  tagname="$STABLE_VERSION"

  # Check if the tag already exists
  if [ $(git tag -l "$tagname") ]; then
    info "A tag for this version ($tagname) already exists"
  else
    # Tag and push commit
    git tag -a tagname $WERCKER_GIT_COMMIT -m "$tagname"
    git push --tags $GIT_REMOTE
  fi
else
  info "Tagging skipped as build was not successful"
fi
