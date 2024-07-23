#!/bin/bash
set -e

until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Use bundle exec to ensure we're using the right version of Rails
bundle exec rails db:prepare

# Use exec to replace the shell with the rails command
exec bundle exec "$@"