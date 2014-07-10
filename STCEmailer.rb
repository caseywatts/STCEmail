require 'bundler'
Bundler.require
require "sinatra/reloader" if development?

# class STCEmailApp < Sinatra::Base
  #require 'twitter-bootstrap-rails'

  #initializing some variables because I'm used to C++
  # success = "yep"
  # from = ''
  # to = ""
  # netid = ""
  # body = "fail"
  # timetosend = false

  def create_incident(params)
    #requires params[:netid] to work, others are optional
    ServiceNow::Configuration.configure(:sn_url => 'https://yaletest.service-now.com', :sn_username => ENV['SN_USERNAME'], :sn_password => ENV['SN_PASSWORD'])
    inc = ServiceNow::Incident.new
    inc.short_description = "report from iOS wifi-reporter"
    inc.description = "netid: #{params[:netid]}\nname: #{params[:name]}\nlocation: #{params[:location]}\nbandwidth: #{params[:avg_bandwidth]}\ntrial1: #{params[:trial1]}\ntrial2: #{params[:trial2]}\ntrial3: #{params[:trial3]}\ncomment: #{params[:comments]}\nmac: #{params[:mac]}"
    inc.caller_id = ServiceNow::User.find(params[:netid]).sys_id
    inc.save!
  end


  get '/' do
    #get all the variables from the erb forms
    # from = params["from"] #"stuartteal@gmail.com"#
    # to = "student.technology@yale.edu"#
    # body = params["problem"] #"hello" #
    # netid = params["netid"] #"sbt3" #
    # model = params["model"]
    # cell = params["cell"]
    # first = params["first"]
    # last = params["last"]
    # program = params["program"]
    # room = params["room"]
    # os = params["os"]
    # serialnumber = params["serialnumber"]
    # problem = params["problem"]
    # username = params["username"]
    # password = params["password"]

    #check if there's a valid from address. The form auto checks that it's an email. the if loop checks that it's not blank.
    # if from.to_s == ""
    #   timetosend = false
    # else
    #   timetosend = true
    # end
    # format the things the way you want them to be sent
    # subject = "[STC " + netid.to_s + "]"

    # body ="This request was sent from our STC Heroku app:
    # Student: " + first.to_s + " " + last.to_s + ", with NETID: " + netid.to_s + " has requested help with his computer.
    # It is a MODEL: " + model.to_s + " running OS: " + os.to_s + " and (s)he is participating in the summer session program: " + program.to_s + " The serial number entered was: " + serialnumber.to_s + " and the student's cell phone number is " + cell.to_s + ".
    # Please enter this information into the description field and apply the generic intake article KB0000636

    # The following is a description of the problem provided by the client:
    # " + body.to_s


    # if timetosend == true
    #   Pony.mail(:to => to, :from => from, :cc => from, :subject => subject,:reply_to => from, :sender => from, :body => body,
    #     #:headers              => {"From:" => from},
    #     :via => :smtp, :via_options => {
    #       :address              => 'smtp.gmail.com',
    #       :port                 => '587',
    #       :enable_starttls_auto => true,
    #       :user_name            => username,
    #       :password             => password,
    #     :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    #     :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server

    #   }
    #   )
    #   success = "Success!
    #   Your Email Was Sent"
    # else
    #   #Failed. Display nothing.
    #   subject = ""
    #   success = ""

    # end

    #run! if app_file == $0
    #end
    #send the variables back to the erb HTML page
    erb :index

    #end the get call
  end

  post '/confirmation' do
    # @inc = create_incident(params)
    @inc = 'an incident'
    @netid = params[:netid]
    # erb :confirmation
    params.inspect
  end
# end