require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    redirect '/foo' do
      new_host 'example.org'
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
