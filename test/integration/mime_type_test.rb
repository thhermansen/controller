require 'test_helper'
require 'lotus/router'

MimeRoutes = Lotus::Router.draw do
  get '/',       to: 'mimes#default'
  get '/custom', to: 'mimes#custom'
end

class MimesController
  include Lotus::Controller

  action 'Default' do
    def call(params)
    end
  end

  action 'Custom' do
    def call(params)
      self.content_type = 'application/xml'
    end
  end
end

describe 'Mime type' do
  before do
    @app = Rack::MockRequest.new(MimeRoutes)
  end

  it 'fallbacks to the default "Content-Type" header when the request is lacking of this information' do
    response = @app.get('/')
    response.headers['Content-Type'].must_equal 'application/octet-stream'
  end

  it 'returns the specified "Content-Type" header' do
    response = @app.get('/custom')
    response.headers['Content-Type'].must_equal 'application/xml'
  end

  it 'sets "Content-Type" header according to "Accept"' do
    response = @app.get('/', 'CONTENT_TYPE' => 'application/png')
    response.headers['Content-Type'].must_equal 'application/png'
  end
end
