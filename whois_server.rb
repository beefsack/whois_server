require 'rubygems'
require 'sinatra'
require 'whois'
require 'json'

get '/:domain' do
  content_type :json
  c = Whois::Client.new
  result = c.query(params[:domain])
  data = {
    :available => result.available?,
    }
  data.to_json
end