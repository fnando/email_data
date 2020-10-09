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
                   :disposable_emails,
                   :country_tlds,
                   :free_email_domains,
                   :tlds
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
