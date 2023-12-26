#!/bin/bash

set -e

rm -f /test_app/tmp/pids/server.pid

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

exec "$@"
