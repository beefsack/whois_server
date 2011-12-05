require 'rubygems'
require 'sinatra'
require 'whois'
require 'json'

def hash_or_nil(value)
  value ? Hash[*value.members.zip(value.values).flatten] : nil
end

disable :protection # This is a read only API, keep it open

get '/:domain' do
  content_type :json
  c = Whois::Client.new
  begin
    result = c.query(params[:domain])
    data = {
      :disclaimer => result.disclaimer,
      :domain => result.domain,
      :domain_id => result.domain_id,
      :referral_whois => result.referral_whois,
      :status => result.status,
      :registered => result.registered?,
      :available => result.available?,
      :created_on => result.created_on,
      :updated_on => result.updated_on,
      :expires_on => result.expires_on,
      :nameservers => result.nameservers,
      }
    data[:registrar] = hash_or_nil(result.registrar)
    data[:registrant_contact] = hash_or_nil(result.registrant_contact)
    data[:admin_contact] = hash_or_nil(result.admin_contact)
    data[:technical_contact] = hash_or_nil(result.technical_contact)
  rescue Whois::Error => e
    data = {
      :error => e
      }
  end
  data.to_json
end

get "/" do
  "Add a domain to the URL to check.  For example: http://#{request.host}/google.com"
end