# Redrate [![Build Status](https://travis-ci.com/nulib/redrate.svg?branch=master)](https://travis-ci.com/nulib/redrate)

A distributed rate limiter for Ruby, based on [ruby-limiter](https://github.com/Shopify/limiter).
By using redis as the ring store, `Redrate` can enforce the rate limit across multiple 
running instances of the same code, e.g., to enforce limits on shared use of a common
rate-limited API or other resource.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redrate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redrate

## Usage

### Basic Usage

To rate limit calling an instance method, a mixin is provided. Simply specify 
the method to me limited, and the maximum rate that the method can be called. 
This rate is (by default) a number of requests per minute.

``` ruby
class Widget
  extend Redrate::Mixin

  # limit the rate we can call tick to 300 times per minute
  #
  # when the rate has been exceeded, a call to tick will block 
  # until the rate limit would not be exceeded
  limit_method :tick, rate: 300

  ...
end
```

To specify the rate in terms of an interval shorter (or longer) than 1 minute, an 
optional `interval` parameter can be provided to specify the throttling period in seconds.

``` ruby
class Widget
  extend Redrate::Mixin

  # limit the rate we can call tick to 5 times per second
  #
  # when the rate has been exceeded, a call to tick will block 
  # until the rate limit would not be exceeded
  limit_method :tick, rate: 5, interval: 1

  ...
end
```

### Advanced Usage

In cases where the mixin is not appropriate the `RedRate::Queue` class can be used 
directly. As in the mixin examples above, the `interval` parameter is optional (and 
defaults to 1 minute).

``` ruby
class Widget
  def initialize
    # create a rate-limited queue which allows 10000 operations per hour
    @queue = RedRate::Queue.new(10000, interval: 3600)
  end

  def tick
    # this operation will block until less than 10000 shift calls have been 
    # made within the last hour
    @queue.shift
    # do something
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nulib/redrate.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
