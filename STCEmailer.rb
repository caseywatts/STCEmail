require 'bundler'
Bundler.require
require_relative 'lib/cas_helpers'
require 'pry'
require 'sinatra/reloader' if development?

  use Rack::Session::Cookie, :secret => ENV['cookiesecret'] #using session cookies in production with CAS is NOT recommended

  helpers CasHelpers

  before do
    process_cas_login(request, session)
  end

  # KB Articles
  TTO_IN_PERSON = "fbebf3339004fc40fde6c4b91cbd300a"

  def create_incident(params)
    ServiceNow::Configuration.configure(:sn_url => ENV['SN_INSTANCE'], :sn_username => ENV['SN_USERNAME'], :sn_password => ENV['SN_PASSWORD'])
    inc = ServiceNow::Incident.new
    # the `params[:netid]` isn't as secure as the `session[:cas_user]` that comes from rubycas
    # secret ENV variables in ~/.localrc for me
    # session={}
    # session[:cas_user] = 'csw3'
    # binding.pry
    inc.caller_id = ServiceNow::User.find(session[:cas_user]).sys_id
    inc.u_contact = ServiceNow::User.find(session[:cas_user]).sys_id
    inc.u_kb_article = TTO_IN_PERSON #this won't apply the associated template, for better or worse
    inc.contact_type = "In Person"
    inc.short_description = "Report From STCEmailApp"
    inc.description = %{
Name: #{params['first']} #{params['last']}
Non-Yale Email: #{params['nonyaleemail']}
Cell: #{params['cell']}
Program Name: #{params['program']}
Room Number: #{params['room']}

Model: #{params['model']}
OS: #{params['os']}
Serial Number: #{params['serialnumber']}

Description of Issue: #{params['problem']}
}.strip
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
    @inc = create_incident(params)
    @netid = session[:cas_user]
    erb :confirmation
    # params.inspect
  end