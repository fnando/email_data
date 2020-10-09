# frozen_string_literal: true

require "test_helper"

class ActiveRecordTest < Minitest::Test
  setup do
    EmailData.source = EmailData::Source::ActiveRecord
  end

  include Tests
end
