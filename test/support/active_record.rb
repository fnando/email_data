# frozen_string_literal: true

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "TLD"
end

ActiveRecord::Base.establish_connection(
  ENV.fetch("DATABASE_URL", "postgresql:///test")
)

ActiveRecord::Schema.define(version: 0) do
  enable_extension "citext"

  create = lambda do |name|
    drop_table name if table_exists?(name)

    create_table name do |t|
      t.citext :name, null: false
    end

    add_index name, :name, unique: true
  end

  create.call(:tlds)
  create.call(:country_tlds)
  create.call(:disposable_emails)
  create.call(:disposable_domains)
  create.call(:free_email_domains)

  copy = lambda do |table_name|
    values = EmailData::Source::FileSystem.public_send(table_name)
    model_name = table_name.to_s.singularize.camelize.to_sym
    model_class = EmailData::Source::ActiveRecord.const_get(model_name)

    entries = values.map do |value|
      {name: value}
    end

    model_class.upsert_all(entries)
  end

  copy.call(:tlds)
  copy.call(:country_tlds)
  copy.call(:disposable_emails)
  copy.call(:disposable_domains)
  copy.call(:free_email_domains)
end