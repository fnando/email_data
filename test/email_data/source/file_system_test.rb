# frozen_string_literal: true

require "test_helper"

class FileSystemTest < Minitest::Test
  setup do
    EmailData.source = EmailData::Source::FileSystem
  end

  test "sets data dir" do
    assert_equal File.expand_path("../../../data", __dir__),
                 EmailData.data_dir.to_s
  end

  include Tests
end
