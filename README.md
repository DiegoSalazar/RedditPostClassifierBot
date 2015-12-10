# RedditPostClassifierBot

This gem wraps the Ruby [nbayes](https://github.com/oasic/nbayes) gem to run Naive Bayes text classification on Reddit posts. It fetches posts from the front, controversial, top, and new pages and classifies them according to what page they were found on. Once trained, it can be used to try and predict if a new post is frontpage material, or looks as such. It is not however, responsible for your karma whoring.

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

Currently this gem is not so much a bot, but a library to help build one. You can play around with it in the terminal:

```shell
irb -r RedditPostClassifierBot
```

The gem comes with a small training data set and you don't have to train it your self, unless you want it to get smarter.

### Classify a single post

```ruby
c = RedditPostClassifierBot.classifier
c.classify "subreddit", "title", "self text or url"
# => "classification"
```

The classification will be one of the pages it thinks this post will be on e.g. hot, controversial, top hour etc. See `RedditTrainer.trained_on` for a full list.

### Classify a whole page or subreddit 

```ruby
classifications = RedditPostClassifierBot.classify_posts "/r/all"
# => { front: ["permalinks to front page classed posts", ...], ... }
```
`classifications` will be a hash where the keys are the predicted classes e.g. `:hot` and the values are arrays of permalinks to the posts it classified under that class.

### Training

```ruby
c = RedditPostClassifierBot.train_classifier
```

After training, the bot will dump its training data to a yml file "./RPCB-nbayes.yml". You can customize the file path by setting `ENV["NBAYES_FILE_PATH"]`.

Further training customization can be done by instantiating `RedditTrainer` directly.

```ruby
trainer = RedditPostClassifierBot::RedditTrainer.new trials, per_page, debug?
```

Arguments:
 - `trials` is an integer specify how many pages to paginate to. Default: 10
 - `per_page` is how many posts to fetch from each page. Default: 200
 - `debug` toggles `puts`ing out what page it's currently classifying.

You can also customize what classes i.e. pages and/or subreddits, the trainer will use for classification by modifying the `RedditPostClassifierBot::RedditTrainer::CLASSES` hash where the keys are the classifications and the values are the relative path to the page to fetch from.

## Todo

 - Figure out a way to fetch low scoring posts to classify as such.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/RedditPostClassifierBot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
