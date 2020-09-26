# frozen_string_literal: true

require "test_helper"

class EmailDataTest < Minitest::Test
  test "sets data dir" do
    assert_equal File.expand_path("../data", __dir__), EmailData.data_dir.to_s
  end

  test "returns tlds" do
    assert_includes EmailData.tlds, "app"
  end

  test "returns country tlds" do
    assert_includes EmailData.country_tlds, "br"
    refute_includes EmailData.country_tlds, "app"
  end

  test "returns disposable domains" do
    assert_includes EmailData.disposable_domains, "dispostable.com"
  end

  test "returns disposable emails" do
    assert_includes EmailData.disposable_emails, "abdumuhammadalitmp@gmail.com"
  end

  test "returns free email services" do
    assert_includes EmailData.free_email_domains, "gmail.com"
  end

  test "ensures free email services aren't marked as disposable" do
    EmailData.free_email_domains.each do |domain|
      refute_includes EmailData.disposable_domains, domain
    end
  end
end
