require_relative '../test_helper'
require 'rack/test'
require 'rack/joint'

class JointTest < MiniTest::Test
  include Rack::Test::Methods

  class SinglePathTest < JointTest
    def app
      single_path_config
    end

    def test_joint
      get '/foo/bar/baz', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/path/to/blah', last_response['location']
    end
  end

  class MultiplePathsTest < JointTest
    def app
      multiple_paths_config
    end

    def test_joint
      get '/dogs/bark.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/bowwow/woof', last_response['location']

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 302, last_response.status
      assert_equal 'http://example.org/meow/meow/mew', last_response['location']

      get '/frog.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/croak', last_response['location']
    end
  end

  class MultipleHostsTest < JointTest
    def app
      multiple_hosts_config
    end

    def test_joint
      get '/dogs/bark.html', {}, 'HTTP_HOST' => 'example.net'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/bowwow/woof', last_response['location']

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/meow/meow/mew', last_response['location']
    end
  end

  class NotSetNewHostTest < JointTest
    def app
      same_host_config
    end

    def test_joint
      get '/dogs/bark.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.com/bowwow/woof', last_response['location']

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 302, last_response.status
      assert_equal 'http://example.com/meow/meow/mew', last_response['location']
    end
  end

  class NotSetNewPathTest < JointTest
    def app
      only_host_config
    end

    def test_joint
      get '/foo', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/foo', last_response['location']
    end
  end

  class SetSameURLTest < JointTest
    def test_joint
      assert_raises Rack::Joint::BadRedirectError do
        same_url_config
      end
    end
  end

  class NoSetPathTest < JointTest
    def app
      single_path_config
    end

    def test_joint
      get '/path-has-not-set-in-config', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 200, last_response.status
    end
  end
end
