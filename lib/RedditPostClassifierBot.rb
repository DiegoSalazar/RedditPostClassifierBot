require "fileutils"
require "nbayes"
require "RedditPostClassifierBot/version"
require "RedditPostClassifierBot/nbayes_classifier"
require "RedditPostClassifierBot/reddit_trainer"

module RedditPostClassifierBot
  def self.classifier
    @classifier ||= RedditTrainer.new.load
  end

  def self.train_classifier
    classifier.train.dump
  end

  def self.classify_posts(path)
    classifier.fetch_and_classify path
  end

  def trained_classifier!
    NBayesClassifier.trained? ? classifier : train_classifier
  end
end
