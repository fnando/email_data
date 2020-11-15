# EmailData

- Ruby:
  [![Tests](https://github.com/fnando/email_data/workflows/Tests/badge.svg)](https://github.com/fnando/email_data/actions?query=workflow%3ATests)
  [![Gem](https://img.shields.io/gem/v/email_data.svg)](https://rubygems.org/gems/email_data)
  [![Gem](https://img.shields.io/gem/dt/email_data.svg?label=gems%20downloads)](https://rubygems.org/gems/email_data)
- NPM:
  [![NPM package version](https://img.shields.io/npm/v/@fnando/email_data.svg)](https://www.npmjs.com/package/@fnando/email_data)
  [![NPM Downloads](https://img.shields.io/npm/dt/@fnando/email_data?label=npm%20downloads)](https://www.npmjs.com/package/@fnando/email_data)
- License:
  ![License](https://img.shields.io/static/v1?label=License&message=MIT&color=4da3dd)

This project is a compilation of datasets related to emails.

- Disposable emails
- Disposable domains
- Free email services
- Roles (e.g. info, spam, etc)

The data is compiled from several different sources, so thank you all for making
this data available.

## Installation

### Ruby

Add this line to your application's Gemfile:

```ruby
gem "email_data"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install email_data

#### Usage

```ruby
require "email_data"

# <Pathname /> instance pointing to the data directory.
EmailData.data_dir

# List of disposable domains. Punycode is expanded into ASCII domains.
EmailData.disposable_domains

# List of disposable emails. Some services use free email like Gmail to create
# disposable emails.
EmailData.disposable_emails

# List of free email services.
EmailData.free_email_domains

# List of roles. Can be used to filter out emails like info@ or all@.
EmailData.roles

# List of private relays like Apple's Hide My Email.
EmailData.private_relays

# List of country tlds.
EmailData.country_tlds

# List of official tlds.
EmailData.tlds

# List of second-level domains.
EmailData.slds
```

#### Data sources

By default, Ruby will load data from filesystem. You may want to load this data
from the database instead. `email-data` has support for ActiveRecord out of the
box. To use the ActiveRecord adapter, you must load
`email_data/source/active_record.rb`. You can easily do it so with Bundler's
`require` key.

```ruby
gem "email_data", require: "email_data/source/active_record"
```

Then, you need to assign the new data source.

```ruby
EmailData.source = EmailData::Source::ActiveRecord
```

If you need to configure a different database connection than the one defined by
`ActiveRecord::Base`, use `EmailData::Source::ActiveRecord::ApplicationRecord`
for that.

##### Creating the tables

To create the tables, use the migration code below (tweak it accordingly if you
use something different than PostgreSQL, or don't want to use `citext`).

```ruby
class SetupEmailData < ActiveRecord::Migration[6.1]
  def change
    enable_extension "citext"

    create_table :tlds do |t|
      t.citext :name, null: false
    end

    add_index :tlds, :name, unique: true

    create_table :slds do |t|
      t.citext :name, null: false
    end

    add_index :slds, :name, unique: true

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

    create_table :roles do |t|
      t.citext :name, null: false
    end

    add_index :roles, :name, unique: true

    create_table :private_relays do |t|
      t.citext :name, null: false
    end

    add_index :private_relays, :name, unique: true
  end
end
```

##### Loading the data

With PostgreSQL, you load the data using the `COPY` command. First, you'll need
to discover where your gems are being installed. Use `gem list` for that.

```console
$ gem list email_data -d

*** LOCAL GEMS ***

email_data (1601479967, 1601260789)
    Author: Nando Vieira
    Homepage: https://github.com/fnando/email_data
    License: MIT
    Installed at (1601479967): /usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0
    This project is a compilation of datasets related to emails.
    Includes disposable emails, disposable domains, and free email
    services.
```

The you can load each dataset using `COPY`:

```sql
COPY tlds (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/tlds.txt';
COPY slds (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/slds.txt';
COPY country_tlds (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/country_tlds.txt';
COPY disposable_emails (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/disposable_emails.txt';
COPY disposable_domains (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/disposable_domains.txt';
COPY free_email_domains (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/free_email_domains.txt';
COPY roles (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/roles.txt';
COPY private_relays (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/private_relays.txt';
```

Alternatively, you could create a migrate that executes that same command; given
that you'd be running Ruby code, you can replace the steps to find the gem path
with `EmailData.data_dir`.

```ruby
class LoadEmailData < ActiveRecord::Migration[6.1]
  def change
    copy = lambda do |table_name|
      connection = ActiveRecord::Base.connection
      data_path = EmailData.data_dir

      connection.execute <<~PG
        COPY #{table_name} (name)
        FROM '#{data_path.join(table_name)}.txt'
        (FORMAT CSV)
      PG
    end

    copy.call(:tlds)
    copy.call(:slds)
    copy.call(:country_tlds)
    copy.call(:disposable_emails)
    copy.call(:disposable_domains)
    copy.call(:free_email_domains)
    copy.call(:roles)
    copy.call(:private_relays)
  end
end
```

### Node.js

```console
$ yarn add @fnando/email_data
```

or

```console
$ npm install @fnando/email_data
```

#### Usage

```js
const disposableEmails = require("@fnando/email_data/data/json/disposable_emails.json");
const disposableDomains = require("@fnando/email_data/data/json/disposable_domains.json");
const freeEmailDomains = require("@fnando/email_data/data/json/free_email_domains.json");
const roles = require("@fnando/email_data/data/json/roles.json");
const privateRelays = require("@fnando/email_data/data/json/private_relays.json");
const tlds = require("@fnando/email_data/data/json/tlds.json");
const slds = require("@fnando/email_data/data/json/slds.json");
const cctlds = require("@fnando/email_data/data/json/country_tlds.json");
```

## Dataset

The dataset is updated automatically. If you have any manual entries you would
like to add, please make a pull request against the files `data/manual/*.txt`.

- `data/manual/disposable_domains.txt`: only domains from disposable servers
  must go here.
- `data/manual/disposable_emails.txt`: only normalized email addresses that use
  free email services must go here. E.g. `d.i.s.p.o.s.a.b.l.e+1234@gmail.com`
  must be added as `disposable@gmail.com`.
- `data/manual/free_email_domains.txt`: only free email services must go here.
- `data/manual/roles.txt`: list of role-based user names like `info` or
  `no-reply`.
- `data/manual/private_relays`: list of private relay services, like Apple's
  Hide My Email.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/fnando/email_data. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the
[code of conduct](https://github.com/fnando/email_data/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EmailData project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/email_data/blob/main/CODE_OF_CONDUCT.md).
