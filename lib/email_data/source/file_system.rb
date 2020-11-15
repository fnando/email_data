# frozen_string_literal: true

module EmailData
  module Source
    class FileSystem
      def self.tlds
        @tlds ||= load_file("tlds.txt")
      end

      def self.slds
        @slds ||= load_file("slds.txt")
      end

      def self.country_tlds
        @country_tlds ||= load_file("country_tlds.txt")
      end

      def self.disposable_emails
        @disposable_emails ||= load_file("disposable_emails.txt")
      end

      def self.disposable_domains
        @disposable_domains ||= load_file("disposable_domains.txt")
      end

      def self.free_email_domains
        @free_email_domains ||= load_file("free_email_domains.txt")
      end

      def self.roles
        @roles ||= load_file("roles.txt")
      end

      def self.load_file(filename)
        EmailData
          .data_dir
          .join(filename)
          .read
          .lines
          .map(&:chomp)
          .reject(&:empty?)
      end
    end
  end
end
