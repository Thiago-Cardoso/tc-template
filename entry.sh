#!/bin/sh
# Install the Gems
bundle check || bundle install
ruby template.rb
