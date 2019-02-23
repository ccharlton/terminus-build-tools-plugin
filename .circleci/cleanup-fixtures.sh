#!/bin/bash

set -e

TERMINUS_SITE=build-tools-$CIRCLE_BUILD_NUM

# Delete our github repository and Pantheon site
#
# Set an environment variable OBLITERATE to control whether to delete our fixtures
#   - always: Always delete fixtures (default)
#   - ok:     Only obliterate if the tests pass; otherwise retain
#   - fail:   Only obliterate if the tests fail.
#   - never:  Never delete fixtures (or any other value other than empty)
if [ -z "$OBLITERATE" ] || [ "x$OBLITERATE" == "xalways" ] || [ "x$OBLITERATE" == "x$1" ] ; then
  terminus build:env:obliterate -n --yes "$TERMINUS_SITE"
fi

# Delete old ssh keys; allow the most-recently-created 12 to remain
for key in $(terminus ssh-key:list --format=csv --fields=ID,Description 2>/dev/null | grep ci-bot-build-tools | sed -e 's/ci-bot-build-tools-//' | sort -rg | sed -e '1,12d' | sed -e 's/,.*//') ; do echo "Remove $key"; terminus ssh-key:remove $key ; done
