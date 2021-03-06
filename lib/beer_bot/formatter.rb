require 'beer_bot/pluralizer'
require 'beer_bot/bar_formatter'
require 'beer_bot/beer_formatter'

module BeerBot
  class Formatter

    def self.format(result, request_params)
      [build_summary(result, request_params),
       BarFormatter.format(result[:bars]),
       BeerFormatter.format(result[:beers])].join("\n")
    end

  private
    extend Pluralizer

    def self.build_summary(result, request_params)
      "@#{request_params['user_name']}: PhillyTapFinder returned " +
      "#{string_with_count('bar', result[:bars].size)} and " +
      "#{string_with_count('beer', result[:beers].size)} for " +
      "'#{request_params['text']}'."
    end
  end
end