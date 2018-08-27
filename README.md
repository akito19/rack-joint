# Rack::Joint

Rack::Joint is a [Rack](https://github.com/rack/rack) middleware which helps to redirect with Ruby DSL.

### Requirements
Rack::Joint requires Ruby 2.4+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-joint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-joint

## Usage

Write settings in `config.ru`. This is a sample:

```ruby
# config.ru
require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    # If you access `http://example.com/dogs/bark.html`,
    # redirect to `http://example.org/bowwow.html` with 301. 
    redirect '/dogs/bark.html' do
      new_host 'example.org'
      to '/bowwow.html'
      status 301
    end

    # If you access `http://example.com/cats.html`,
    # redirect to `http://example.org/meow/mew` with 302.
    redirect '/cats.html' do
      new_host 'example.org'
      to '/meow/mew'
      status 302
    end

  host 'example.net' do
    # If you access `http://example.net/frog.html`,
    # redirect to `http://example.net/croak` with 301.
    redirect '/frog.html' do
      to '/croak'
    end
    
    # If you access `http://example.net/quack`,
    # redirect to `http://example.org/quack` with 301.
    redirect '/quack' do
      new_host 'example.org' 
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
```

You can use following resources with block.

| Resource | Description |
| :------- | :---------- |
| `host`   | Host name. |
| `redirect` | Path name. |
| `new_host` | A new host name redirects to. Optional. |
| `to` | A new path name redirects to. Optional. |
| `status` | Status when redirecting. You can use `301`, `302`, `303`, `307`, `308`; which is `301` to default. |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akito19/rack-joint.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).