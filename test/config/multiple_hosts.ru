require 'rack/joint'

NEW_HOST = 'example.org'
use Rack::Joint do
  host 'example.net' do
    redirect '/dogs/bark.html' do
      new_host NEW_HOST
      to '/bowwow/woof'
    end
  end

  host 'example.com' do
    redirect '/cats/meow.html' do
      new_host NEW_HOST
      to '/meow/meow/mew'
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
