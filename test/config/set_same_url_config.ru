require 'rack/joint'

use Rack::Joint do
  host 'example.com' do
    redirect '/foo/bar/baz' do
      to '/foo/bar/baz'
      status 301
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Hello World!']] }
