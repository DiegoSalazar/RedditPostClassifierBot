module RedditPostClassifierBot
  class RedditTrainer
    REDDIT_URL = "https://www.reddit.com"
    CLASSES = {
      hot: "/",
      new_post: "/new/",
      rising: "/rising/",
      controversial: "/controversial/",
      top_hour: "/top/",
      top_day: "/top/?sort=top&t=day",
      top_week: "/top/?sort=top&t=week",
      top_month: "/top/?sort=top&t=month",
      top_year: "/top/?sort=top&t=year"
    }

    attr_reader :classifications

    def self.trained_on
      CLASSES.KEYS
    end

    def initialize(trials = 10, per_page = 200, debug = true)
      @max_trials, @per_page, @debug = trials, per_page, debug
      @posts, @trials_done = [], 0
    end

    def nbayes
      @nbayes ||= RedditPostClassifierBot::NBayesClassifier.new
    end

    def train(classes = CLASSES)
      classes.each do |classification, path|
        log "training on #{classification} posts, page #{@trials_done} of #{@max_trials}"

        reddit(path)["data"]["children"].each do |p|
          @posts << (post = Post.new p)
          nbayes.train post.serialize, classification
        end
      end

      @trials_done += 1
      recurse_to_next_page CLASSES, @posts.last if @trials_done <= @max_trials
      self
    end

    def classify(subreddit, title, post)
      @classifications = nbayes.classify subreddit, title, post
      @classifications.max_class
    end

    def dump
      nbayes.dump; self
    end

    def load
      train and dump unless nbayes.load
      self
    end

    def fetch_and_classify(path = CLASSES[:front])
      posts = reddit(path)["data"]["children"]
      log "Classifying #{posts.size} posts"

      posts.inject({}) do |h, p|
        post = Post.new p
        classification = classify post.subreddit, post.title, post.body
        h.merge! uri_with_base(post.path).to_s => classification
      end.group_by { |_, c| c }
    end

    def inspect
      "<#{self.class}:#{object_id.to_s(16)} @max_trials=#{@max_trials.inspect} @per_page=#{@per_page.inspect} @debug=#{@debug.inspect} @posts.size=#{@posts.size}>"
    end

    private 

    def reddit(path)
      path = path.split("?")
      path = "#{path[0]}.json?#{path[1]}"
      uri = uri_with_base path
      cmd = "curl -s -c \"reddit_session=#{ENV["REDDIT_SESSION_ID"]}\" #{uri}"
      
      JSON.parse `#{cmd}` rescue { "data" => { "children" => [] }}
    end

    def recurse_to_next_page(classes, last_post)
      classes = classes.inject({}) do |h, (k, v)|
        u = uri_with_base v
        u.query = "count=#{@per_page}&after=#{last_post.full_id}"
        h.merge! k => u.to_s
      end

      train classes
    end

    def uri_with_base(path, base = REDDIT_URL)
      URI.parse (s = URI.join(base, path)) rescue s # ignore bad uri
    end

    def log(msg)
      puts "[#{self.class}] #{msg}" if @debug
    end

    class Post
      attr_reader :full_id, :path, :subreddit, :title, :body

      def initialize(json)
        @data = json["data"]
        @full_id = "#{json["kind"]}_#{@data["id"]}"
        @path = @data["permalink"]
        @subreddit = @data["subreddit"]
        @title = @data["title"]
        @body = (@data["selftext"].to_s.empty? ? @data["url"] : @data["selftext"]).to_s
      end

      def serialize
        "#{@data["subreddit"]}\n#{@data["title"]}\n#{@data["url"]}\n#{@data["selftext"]}"
      end
    end
  end
end