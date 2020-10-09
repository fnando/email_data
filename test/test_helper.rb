# frozen_string_literal: true

require "bundler/setup"

require "minitest/utils"
require "minitest/autorun"
require "email_data"
require "email_data/source/active_record"

require_relative "support/tests"
require_relative "support/active_record"
