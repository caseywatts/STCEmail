require 'bundler'
Bundler.require
require "sinatra/reloader" if development?

  def create_incident(params)
    #requires params[:netid] to work, others are optional
    ServiceNow::Configuration.configure(:sn_url => 'https://yaletest.service-now.com', :sn_username => ENV['SN_USERNAME'], :sn_password => ENV['SN_PASSWORD'])
    inc = ServiceNow::Incident.new
    inc.caller_id = ServiceNow::User.find(params[:netid]).sys_id
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
    erb :index
  end

  post '/confirmation' do
    # Hopefully after the incident is created some data is returned and we can display that?
    # @inc = create_incident(params)
    @inc = 'an incident'
    @netid = params[:netid]
    # erb :confirmation
    params.inspect
  end