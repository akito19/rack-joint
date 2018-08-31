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
      assert_equal 'Redirect from: http://example.com/foo/bar/baz', last_response.body
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
      assert_equal 'Redirect from: http://example.com/dogs/bark.html', last_response.body

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 302, last_response.status
      assert_equal 'http://example.org/meow/meow/mew', last_response['location']
      assert_equal 'Redirect from: http://example.com/cats/meow.html', last_response.body

      get '/frog.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/croak', last_response['location']
      assert_equal 'Redirect from: http://example.com/frog.html', last_response.body
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
      assert_equal 'Redirect from: http://example.net/dogs/bark.html', last_response.body

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/meow/meow/mew', last_response['location']
      assert_equal 'Redirect from: http://example.com/cats/meow.html', last_response.body
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
      assert_equal 'Redirect from: http://example.com/dogs/bark.html', last_response.body

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 302, last_response.status
      assert_equal 'http://example.com/meow/meow/mew', last_response['location']
      assert_equal 'Redirect from: http://example.com/cats/meow.html', last_response.body
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
      assert_equal 'Redirect from: http://example.com/foo', last_response.body
    end
  end

  class SetSameURLTest < JointTest
    def app
      same_url_config
    end

    def test_joint
      assert_raises Rack::Joint::BadRedirectError do
        get '/foo/bar/baz', {}, 'HTTP_HOST' => 'example.com'
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

  class HostWithSSLTest < JointTest
    def app
      hosts_with_ssl_config
    end

    def test_joint
      get '/dogs/bark.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'https://example.org/bowwow/woof', last_response['location']
      assert_equal 'Redirect from: http://example.com/dogs/bark.html', last_response.body

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/meow/meow/mew', last_response['location']
      assert_equal 'Redirect from: http://example.com/cats/meow.html', last_response.body
    end
  end

  class AccessWithSSLHostTest < JointTest
    def app
      get_url_with_ssl_config
    end

    def test_joint
      get '/foo/bar/baz', {}, 'HTTP_HOST' => 'example.com', 'HTTPS' => 'on'
      assert_equal 301, last_response.status
      assert_equal 'https://example.org/path/to/blah', last_response['location']
      assert_equal 'Redirect from: https://example.com/foo/bar/baz', last_response.body

      get '/dogs/bark.html', {}, 'HTTP_HOST' => 'example.com', 'HTTPS' => 'on'
      assert_equal 301, last_response.status
      assert_equal 'http://example.org/bowwow', last_response['location']
      assert_equal 'Redirect from: https://example.com/dogs/bark.html', last_response.body

      get '/cats/meow.html', {}, 'HTTP_HOST' => 'example.com', 'HTTPS' => 'on'
      assert_equal 301, last_response.status
      assert_equal 'https://example.org/meow', last_response['location']
      assert_equal 'Redirect from: https://example.com/cats/meow.html', last_response.body
    end
  end
end
