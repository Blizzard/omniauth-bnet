# OmniAuth Bnet

[![Gem
Version](https://badge.fury.io/rb/omniauth-bnet.svg)](http://badge.fury.io/rb/omniauth-bnet)

This is an OmniAuth strategy for authenticating to Blizzard's Battle.net OAuth
service. In order to use it you need to register an application at the
[Battle.net Developer Portal](https://develop.battle.net/)

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-bnet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-bnet

## Usage

    use OmniAuth::Builder do
        provider :bnet, ENV['BNET_KEY'], ENV['BNET_SECRET']
    end

### Scopes

In order to provide a list of scopes to request from battle.net:

    use OmniAuth::Builder do
        provider :bnet, ENV['BNET_KEY'], ENV['BNET_SECRET'], scope: "wow.profile,sc2.profile"
    end

## License

[The MIT License](http://opensource.org/licenses/MIT)
