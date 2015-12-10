# RedditPostClassifierBot

This gem wraps the Ruby [nbayes](https://github.com/oasic/nbayes) gem to run text classification on Reddit posts. It fetches posts from the front, controversial, top pages and bad posts and classifies them according to what page they were found on or if it was just bad (negative or zero votes). Once trained, it can be used to try and predict if a new post is frontpage material, or looks as such. It is not however, responsible for your karma whoring.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'RedditPostClassifierBot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install RedditPostClassifierBot

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/RedditPostClassifierBot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
