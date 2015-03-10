require 'rack/test'
require 'test_helper'

class BeerBotTest < Minitest::Unit::TestCase
  include Rack::Test::Methods

  def app
    BeerBot::App
  end

  def setup
    Celluloid.boot
    mock_search
  end

  def test_slack_integration
    mock_slacker
    post '/', params=request_params
  end

  def test_bars_endpoint
    get '/bars', params=request_params
    assert last_response.ok?
    assert_equal last_response.body, result[:bars].to_json
  end

  def test_beers_endpoint
    get '/beers', params=request_params
    assert last_response.ok?
    assert_equal last_response.body, result[:beers].to_json
  end

  private

  def mock_search
    search = Minitest::Mock.new
    search.expect :find, result, [request_params]
    Tapfinder::Search.expects(:new).returns(search)
  end

  def mock_slacker
    slacker = Minitest::Mock.new
    slacker.expect :valid?, true, [request_params]
    slacker.expect :respond_with, nil, [result, request_params]
    BeerBot::Slacker.expects(:new).returns(slacker)
  end

  def result
    { beers: ['The beers'], bars: ['The bars'] }
  end

  def request_params
    { 'text' => 'The search' }
  end
end