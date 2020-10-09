# frozen_string_literal: true

require "bundler/setup"

require "email_data"
require "minitest/utils"
require "minitest/autorun"

Dir["#{__dir__}/support/**/*.rb"].sort.each do |file|
  require file
end
