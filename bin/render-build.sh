#!/usr/bin/env bash

set -o errexit

bundle install --without development test
bin/rails assets:precompile
bin/rails assets:clean

# DB migrated already in supbase.
bin/rails db:migrate
