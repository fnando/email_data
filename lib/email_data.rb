# frozen_string_literal: true

require "forwardable"
require "pathname"

module EmailData
  require "email_data/version"
  require "email_data/source/file_system"

  class << self
    extend Forwardable

    def_delegators :source,
                   :disposable_domains,
                   :disposable_domains_with_mx,
                   :disposable_domains_without_mx,
                   :disposable_emails,
                   :country_tlds,
                   :free_email_domains,
                   :private_relays,
                   :tlds,
                   :slds,
                   :roles,
                   :dnsbls
  end

  def self.source=(source)
    @source = source
  end

  def self.source
    @source
  end

  def self.data_dir
    Pathname.new(File.expand_path("../data", __dir__))
  end

  self.source = EmailData::Source::FileSystem
end
