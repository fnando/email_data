# frozen_string_literal: true

ActiveRecord::Base.establish_connection(
  ENV.fetch("DATABASE_URL", "postgresql:///test")
)

ActiveRecord::Schema.define(version: 0) do
  enable_extension "citext"

  create_table :tlds do |t|
    t.citext :name, null: false
  end

  add_index :tlds, :name, unique: true

  create_table :country_tlds do |t|
    t.citext :name, null: false
  end

  add_index :country_tlds, :name, unique: true

  create_table :disposable_emails do |t|
    t.citext :name, null: false
  end

  add_index :disposable_emails, :name, unique: true

  create_table :disposable_domains do |t|
    t.citext :name, null: false
  end

  add_index :disposable_domains, :name, unique: true

  create_table :free_email_domains do |t|
    t.citext :name, null: false
  end

  add_index :free_email_domains, :name, unique: true

  copy = lambda do |table_name|
    query = <<~PG
      COPY
      #{table_name} (name)
      FROM '#{__dir__}/../../data/#{table_name}.txt'
      (FORMAT CSV)
    PG
    ActiveRecord::Base.connection.execute(query)
  end

  copy.call(:tlds)
  copy.call(:country_tlds)
  copy.call(:disposable_emails)
  copy.call(:disposable_domains)
  copy.call(:free_email_domains)

rescue ActiveRecord::StatementInvalid
  puts "=> Test migrations already applied; skipping"
end
