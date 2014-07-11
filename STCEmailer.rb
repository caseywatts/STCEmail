require 'bundler'
Bundler.require
require_relative 'lib/cas_helpers'
require 'sinatra/reloader' if development?

  use Rack::Session::Cookie, :secret => ENV['cookiesecret'] #using session cookies in production with CAS is NOT recommended

  helpers CasHelpers

  before do
    process_cas_login(request, session)
  end

  def create_incident(params)
    ServiceNow::Configuration.configure(:sn_url => ENV['SN_INSTANCE'], :sn_username => ENV['SN_USERNAME'], :sn_password => ENV['SN_PASSWORD'])
    inc = ServiceNow::Incident.new
    # the `params[:netid]` isn't as secure as the `session[:cas_user]` that comes from rubycas
    inc.caller_id = ServiceNow::User.find(session[:cas_user]).sys_id
    inc.short_description = "Report From STCEmailApp"
    inc.description = %{
      Name: #{params[:first]} #{params[:last]}
      Non-Yale Email: #{params[:nonyaleemail]}
      Cell: #{params[:cell]}
      Program Name: #{params[:program]}
      Room Number: #{params[:room]}

      Model: #{params[:model]}
      OS: #{params[:os]}
      Serial Number: #{params[:serialnumber]}

      Description of Issue: #{params[:problem]}
    }
    inc.save!
  end

  get '/' do
    # Anyone can see this page, no filter
    erb :welcome
  end

  get '/newticket' do
    require_authorization(request, session) unless logged_in?(request, session)
    @netid = session[:cas_user]
    erb :index
  end

  post '/confirmation' do
    require_authorization(request, session) unless logged_in?(request, session)
    # Hopefully after the incident is created some data is returned and we can display that?
    # @inc = create_incident(params)
    @inc = 'an incident'
    @netid = session[:cas_user]
    # erb :confirmation
    params.inspect
  end