#!/usr/bin/env ruby
# frozen_string_literal: true

# This example provides login links for github and bnet in order to test that
# bnet oauth is correctly working.

require 'omniauth'
require 'omniauth-bnet'
require 'omniauth-github'
require 'sinatra'

require 'dotenv'
Dotenv.load

# Uncomment to see requests going back and forth <3
# require 'httplog'
# HttpLog.options[:log_headers] = true

configure do
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET']
    provider :bnet, ENV['BNET_ID'], ENV['BNET_SECRET'], scope: 'wow.profile sc2.profile'
  end

  OmniAuth.config.full_host = 'http://127.0.0.1:4567'

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
end

get '/' do
  haml :index
end

get '/auth/:name/callback' do
  auth = request.env['omniauth.auth']
  session[:user_id] = auth['uid']
  session[:user_info] = auth['info']
  session[:debug] = auth.to_yaml
  redirect OmniAuth.config.full_host
end

get '/auth/failure' do
  haml :failure
end

get '/auth/:provider/deauthorized' do
  haml :deauthorized
end

get '/logout' do
  session[:user_id] = nil
  session[:user_info] = nil
  redirect OmniAuth.config.full_host
end
