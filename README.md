# Cropio::Ruby

Cropio-Ruby provides simple ActiveRecord-like wrappings for Cropio API.
Currently it supports [Cropio APIv3](http://docs.cropioapiv3.apiary.io/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cropio-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cropio-ruby

## Usage

Require it:

```ruby
require 'cropio'
```

To load Cropio resources to current namespace:

```ruby
include Cropio::Resources
```

You need to specify your email and password. At first time when you'll
try to request some data from Cropio gem will get authentication token.

```ruby
Cropio.credentials = {
  email: 'your account email',
  password: 'your password'
}

Crop.all

Cropio.credentials.api_token
=> "authenticationToken"
```

Currently supported API methods is:

- index

```ruby
Crop.all
```

- get record by id
```ruby
Crop.find(1)
```

- create

```ruby
Crop.new(name: 'new crop').save
```

- update

```ruby
crop = Crop.all.last
crop.short_name = 'new'
crop.save

```


- delete

```ruby
crop = Crop.all.last
crop.destroy
```

- changes
```ruby
Crop.changes('2012-01-01', '2016-01-01')
Crop.changes(Date.new(2012, 1, 1))
```

- get all ids 
```ruby
Crop.ids
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/cropio/cropio-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
