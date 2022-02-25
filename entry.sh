#!/bin/sh
# Install the Gems
bundle check || bundle install
bundle exec rspec