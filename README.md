# EmailData

This project is a compilation of datasets related to emails.

- Disposable emails
- Disposable domains
- Free email services

The data is compiled from several different sources, so thank you all for making
this data available.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "email_data"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install email_data

## Usage

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
  These are services that allow anyone to create an email account, even if it's
  just a trial without credit cards.

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
