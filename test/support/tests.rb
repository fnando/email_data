# frozen_string_literal: true

module Tests
  def self.included(base)
    base.class_eval do
      test "returns tlds" do
        assert_includes EmailData.tlds, "app"
      end

      test "returns country tlds" do
        assert_includes EmailData.country_tlds, "br"
        refute_includes EmailData.country_tlds, "app"
      end

      test "returns slds" do
        assert_includes EmailData.slds, "gov.br"
        refute_includes EmailData.slds, "br"
      end

      test "returns disposable domains" do
        assert_includes EmailData.disposable_domains, "dispostable.com"
      end

      test "returns disposable domains with mx" do
        assert_includes EmailData.disposable_domains_with_mx, "nada.email"
      end

      test "returns disposable domains without mx" do
        assert_includes EmailData.disposable_domains_without_mx,
                        "zyte.site"
      end

      test "returns disposable emails" do
        assert_includes EmailData.disposable_emails,
                        "abdumuhammadalitmp@gmail.com"
      end

      test "returns free email services" do
        assert_includes EmailData.free_email_domains, "gmail.com"
      end

      test "ensures free email services aren't marked as disposable" do
        EmailData.free_email_domains.each do |domain|
          refute EmailData.disposable_domains.include?(domain),
                 "expected #{domain} not to be marked as a " \
                 "disposable domain"
        end
      end

      test "returns roles" do
        assert_includes EmailData.roles, "info"
      end
    end
  end
end
