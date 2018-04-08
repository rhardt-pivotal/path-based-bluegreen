
  require 'rubygems'
  require 'sinatra'
  require 'yaml'
  require 'json'
  require 'net/http'

  set :requests, 0
  set :bind, '0.0.0.0'

  ev = JSON.pretty_generate(ENV.to_hash)

  get '/killSwitch' do
    Kernel.exit!
  end

  get '/load' do
    i = 0
    myStr = "Kill the CPU!!!"
    buff = ""

    while i < 50000  do
      buff += myStr.to_s
      buff.reverse!
      i += 1
    end
    settings.requests += 1
    "<h2>I'm healthy!</h2>"
  end

  get '/health' do
    settings.requests += 1
    "<h2>I'm healthy!</h2>"
  end

  get '/v1.1/idx' do
     settings.requests += 1
     app_info = ENV['VCAP_APPLICATION'] ? JSON.parse(ENV['VCAP_APPLICATION']) : Hash.new
     ENV['APP_NAME'] = app_info["application_name"]
     ENV['APP_INSTANCE'] = app_info["instance_index"].to_s
     ENV['APP_MEM'] = app_info["limits"] ? app_info["limits"]["mem"].to_s : " "
     ENV['APP_DISK'] = app_info["limits"] ? app_info["limits"]["disk"].to_s : " "
     ENV['APP_IP'] = IPSocket.getaddress(Socket.gethostname)
     ENV['APP_PORT'] = app_info["port"].to_s
     ENV['SERVICE_JSON'] = JSON.pretty_generate(JSON.parse(ENV['VCAP_SERVICES']))
     ENV['ENV_DUMP'] = ev
     print('This is a custom log message')
     erb :'index'
  end

  get %r{/v1.1(/?)$} do
    redirect to('/v1.1/idx')
  end

  get '/v1.1/*' do
    puts (File.join(settings.public_folder, "#{params[:splat].first}"))
    send_file File.join(settings.public_folder, "#{params[:splat].first}")
  end
