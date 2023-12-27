#!/bin/bash

set -e

rm -f /test_app/tmp/pids/server.pid


bundle install
bundle exec rails assets:clobber
bundle exec rails assets:precompile
bundle exec rails db:migrate


exec "$@"
