module RedditPostClassifierBot
  class NBayesClassifier
    NBAYES_FILE = "./RPCB-nbayes.yml"

    def initialize
      @nbayes = NBayes::Base.new
    end

    def train(text, classification)
      @nbayes.train tokenize(text), classification
      self
    end

    def classify(subreddit, title, post)
      @nbayes.classify tokenize("#{subreddit}\n#{title}\n#{post}")
    end

    def dump
      @nbayes.dump NBAYES_FILE
    end

    def load
      @nbayes.load NBAYES_FILE
      true
    rescue Errno::ENOENT, NoMethodError
      FileUtils.touch NBAYES_FILE unless File.exists?(NBAYES_FILE)
      false
    end

    private def tokenize(text = @text)
      text.split(/\s+/)
    end
  end
end
