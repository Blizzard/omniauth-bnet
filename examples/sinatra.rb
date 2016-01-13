#!/usr/bin/env ruby

# This example provides login links for github and bnet in order to test that
# bnet oauth is correctly working.

require 'omniauth'
require 'omniauth-bnet'
require 'omniauth-github'
require 'sinatra'

# Uncomment to see requests going back and forth <3
# require 'httplog'
# HttpLog.options[:log_headers] = true

configure do
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET']
    provider :bnet, ENV['BNET_ID'], ENV['BNET_SECRET'], scope: "wow.profile sc2.profile"
  end

  OmniAuth.config.full_host = "https://local.test.battle.net"

  enable :sessions
  enable :inline_templates
end

helpers do
  def current_user
    session[:user_id]
  end

  def current_user_info
    session[:user_info]
  end

  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  if current_user
    erb '<h1>Sinatra OAuth Test</h1><%=current_user%><br><pre><%=h current_user_info%></pre><br><pre><%=h session[:debug]%></pre><br><a href="/logout">Logout</a>'
  else
    erb '<h1>Sinatra OAuth Test</h1><a href="/auth/github">Login with Github</a><br><a href="/auth/bnet">Login with Bnet</a>'
  end
end

get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  session[:user_id] = auth["uid"]
  session[:user_info] = auth["info"]
  session[:debug] = auth.to_yaml
  redirect OmniAuth.config.full_host
end

get '/auth/failure' do
  erb "<h1>Authentication Failed:</h1><h3>message:#{params[:message]}<h3> <pre>#{params}</pre>"
end

get '/auth/:provider/deauthorized' do
  erb "#{params[:provider]} has deauthorized this app."
end

get '/logout' do
  session[:user_id] = nil
  session[:user_info] = nil
  redirect OmniAuth.config.full_host
end

__END__

@@ layout
<html>
  <head>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

    <!-- Latest compiled and minified JavaScript -->
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
  </head>
  <body>
    <div class='container'>
      <div class='content'>
        <%= yield %>
      </div>
    </div>
  </body>
</html>
