require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    redirect '/dogs/bark.html' do
      new_host 'example.org'
      to '/bowwow/woof'
    end

    redirect '/cats/meow.html' do
      new_host 'example.org'
      to '/meow/meow/mew'
      status 302
    end

    redirect '/frog.html' do
      new_host 'example.org'
      to '/croak'
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
