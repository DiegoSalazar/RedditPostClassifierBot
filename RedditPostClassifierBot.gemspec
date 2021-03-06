# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'RedditPostClassifierBot/version'

Gem::Specification.new do |spec|
  spec.name          = "RedditPostClassifierBot"
  spec.version       = RedditPostClassifierBot::VERSION
  spec.authors       = ["Diego Salazar"]
  spec.email         = ["diego@greyrobot.com"]

  spec.summary       = %q{Run Naive Bayes classification of Reddit posts}
  spec.description   = %q{This gem wraps Ruby's nbayes gem to do text classification of Reddit posts. It classifies posts according to where they were fetch - frontpage, controversial, top, or bad posts. It can be used to try to predict if a new post will make it to the front page, maybe.}
  spec.homepage      = "https://github.com/DiegoSalazar/RedditPostClassifierBot"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  spec.add_dependency "nbayes"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
