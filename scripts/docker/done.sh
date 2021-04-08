#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

echo "The site should now be running at http://ding2.docker"
echo ""
echo "You now have a blank site. You can install example content using:"
echo "$ make install-example-content"
echo ""
echo "Notice: you need a Reload VPN for some aspects of opensearch to work."
