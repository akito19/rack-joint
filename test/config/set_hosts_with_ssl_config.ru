require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    redirect '/dogs/bark.html' do
      ssl true
      new_host 'example.org'
      to '/bowwow/woof'
    end

    redirect '/cats/meow.html' do
      ssl false
      new_host 'example.org'
      to '/meow/meow/mew'
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
