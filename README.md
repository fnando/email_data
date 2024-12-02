# email_data

[![Tests](https://github.com/fnando/email_data/workflows/ruby-tests/badge.svg)](https://github.com/fnando/email_data)
[![Gem version](https://img.shields.io/gem/v/email_data.svg?label=Gem%20version)](https://rubygems.org/gems/email_data)
[![Gem downloads](https://img.shields.io/gem/dt/email_data.svg?label=Gem%20downloads)](https://rubygems.org/gems/email_data)
[![NPM version](https://img.shields.io/npm/v/%40fnando%2Femail_data.svg?label=NPM%20version)](https://npmjs.org/package/@fnando/email_data)
[![NPM downloads](https://img.shields.io/npm/dt/%40fnando%2Femail_data.svg?label=NPM%20downloads)](https://npmjs.org/package/@fnando/email_data)

This project is a compilation of datasets related to emails.

- Disposable emails
- Disposable domains
- Free email services
- Roles (e.g. info, spam, etc)

The data is compiled from several different sources, so thank you all for making
this data available.

## Ruby

### Installation

```bash
gem install email_data
```

Or add the following line to your project's Gemfile:

```ruby
gem "email_data"
```

### Usage

```ruby
require "email_data"

# <Pathname /> instance pointing to the data directory.
EmailData.data_dir

# List of disposable domains. Punycode is expanded into ASCII domains.
EmailData.disposable_domains
EmailData.disposable_domains_with_mx
EmailData.disposable_domains_without_mx

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

# A list of DNSBL providers.
EmailData.dnsbls
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

    create_table :disposable_domains_with_mx do |t|
      t.citext :name, null: false
    end

    add_index :disposable_domains_with_mx, :name, unique: true

    create_table :disposable_domains_without_mx do |t|
      t.citext :name, null: false
    end

    add_index :disposable_domains_without_mx, :name, unique: true

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

    create_table :dnsbls do |t|
      t.citext :name, null: false
    end

    add_index :dnsbls, :name, unique: true
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
COPY disposable_domains_with_mx (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/disposable_domains_with_mx.txt';
COPY disposable_domains_without_mx (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/disposable_domains_without_mx.txt';
COPY free_email_domains (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/free_email_domains.txt';
COPY roles (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/roles.txt';
COPY private_relays (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/private_relays.txt';
COPY dnsbls (name) FROM '/usr/local/ruby/2.7.1/lib/ruby/gems/2.7.0/gems/email_data-1601479967/data/dnsbls.txt';
```

Alternatively, you could create a migration that executes that same command;
given that you'd be running Ruby code, you can replace the steps to find the gem
path with `EmailData.data_dir`.

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
    copy.call(:disposable_domains_with_mx)
    copy.call(:disposable_domains_without_mx)
    copy.call(:free_email_domains)
    copy.call(:roles)
    copy.call(:private_relays)
    copy.call(:dnsbls)
  end
end
```

## Node.js

### Installation

```console
$ yarn add @fnando/email_data
```

or

```console
$ npm install @fnando/email_data
```

### Usage

```js
const disposableEmails = require("@fnando/email_data/data/json/disposable_emails.json");
const disposableDomains = require("@fnando/email_data/data/json/disposable_domains.json");
const disposableDomainsWithMx = require("@fnando/email_data/data/json/disposable_domains_with_mx.json");
const disposableDomainsWithoutMx = require("@fnando/email_data/data/json/disposable_domains_without_mx.json");
const freeEmailDomains = require("@fnando/email_data/data/json/free_email_domains.json");
const roles = require("@fnando/email_data/data/json/roles.json");
const privateRelays = require("@fnando/email_data/data/json/private_relays.json");
const tlds = require("@fnando/email_data/data/json/tlds.json");
const slds = require("@fnando/email_data/data/json/slds.json");
const cctlds = require("@fnando/email_data/data/json/country_tlds.json");
const dnsbls = require("@fnando/email_data/data/json/dnsbls.json");
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
- `data/manual/private_relays.txt`: list of private relay services, like Apple's
  Hide My Email.

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- https://github.com/fnando/email_data/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/fnando/email_data/blob/main/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at https://github.com/fnando/email_data/blob/main/LICENSE.md.

## Code of Conduct

Everyone interacting in the email_data project's codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/email_data/blob/main/CODE_OF_CONDUCT.md).
