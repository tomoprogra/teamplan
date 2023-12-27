#!/bin/bash

set -e

rm -f /test_app/tmp/pids/server.pid

if [ "$RAILS_ENV" = "production" ]; then
bundle install
bundle exec rails assets:clobber
bundle exec rails assets:precompile
bundle exec rails db:migrate
fi

exec "$@"
bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0