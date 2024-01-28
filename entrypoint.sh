#!/bin/bash

set -e

rm -f /test_app/tmp/pids/server.pid

if [ "$RAILS_ENV" = "production" ]; then
  echo "Production environment detected. Running production-specific tasks..."

  bundle install --without development test
  bundle exec rails assets:clobber
  bundle exec rails assets:precompile
  bundle exec rails db:migrate
  #bundle exec rails db:seed
  #DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate:reset
fi

exec "$@"
