# frozen_string_literal: true

require "email_data"

begin
  require "active_record"
rescue LoadError
  raise "activerecord is not part of the bundle. Add it to Gemfile."
end

module EmailData
  module Source
    class ActiveRecord
      class ApplicationRecord < ::ActiveRecord::Base
        self.abstract_class = true
      end

      class TLD < ApplicationRecord
        self.table_name = "tlds"
      end

      class SLD < ApplicationRecord
        self.table_name = "slds"
      end

      class CountryTLD < ApplicationRecord
        self.table_name = "country_tlds"
      end

      class DisposableEmail < ApplicationRecord
        self.table_name = "disposable_emails"
      end

      class DisposableDomain < ApplicationRecord
        self.table_name = "disposable_domains"
      end

      class FreeEmailDomain < ApplicationRecord
        self.table_name = "free_email_domains"
      end

      class Role < ApplicationRecord
        self.table_name = "roles"
      end

      class PrivateRelay < ApplicationRecord
        self.table_name = "private_relays"
      end

      class Collection
        def initialize(model)
          @model = model
        end

        def include?(value)
          @model.where(name: value).exists?
        end

        def each(&block)
          @model.find_each(&block)
        end
      end

      def self.tlds
        @tlds ||= Collection.new(TLD)
      end

      def self.slds
        @slds ||= Collection.new(SLD)
      end

      def self.country_tlds
        @country_tlds ||= Collection.new(CountryTLD)
      end

      def self.disposable_emails
        @disposable_emails ||= Collection.new(DisposableEmail)
      end

      def self.disposable_domains
        @disposable_domains ||= Collection.new(DisposableDomain)
      end

      def self.free_email_domains
        @free_email_domains ||= Collection.new(FreeEmailDomain)
      end

      def self.roles
        @roles ||= Collection.new(Role)
      end

      def self.private_relays
        @private_relays ||= Collection.new(PrivateRelay)
      end
    end
  end
end
