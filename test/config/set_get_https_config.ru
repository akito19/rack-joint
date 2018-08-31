require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    redirect '/foo/bar/baz' do
      ssl true
      new_host 'example.org'
      to '/path/to/blah'
    end

    redirect '/dogs/bark.html' do
      ssl false
      new_host 'example.org'
      to '/bowwow'
    end

    redirect '/cats/meow.html' do
      new_host 'example.org'
      to '/meow'
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
