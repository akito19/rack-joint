require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    redirect '/dogs/bark.html' do
      to '/bowwow/woof'
    end

    redirect '/cats/meow.html' do
      to '/meow/meow/mew'
      status 302
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
