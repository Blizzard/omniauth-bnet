require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    class Bnet < OmniAuth::Strategies::OAuth2
      option :region, :us
      option :client_options, {
        :scope => 'wow.profile sc2.profile'
      }

      def client
        # Setup urls based on region option
        if !options.client_options.has_key(:authorize_url)
          options.client_options[:authorize_url] = "https://#{getHost(options.region)}/oauth/authorize"
        end
        if !options.client_options.has_key(:token_url)
          options.client_options[:token_url] = "https://#{getHost(options.region)}/oauth/token"
        end
        if !options.client_options.has_key(:site)
          options.client_options[:site] = "https://#{getMasheryHost(options.region)}/"
        end

        super
      end

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['id'].to_s }

      info do
        raw_info
      end

      def raw_info
        return @raw_info if @raw_info

        access_token.options[:mode] = :query

        @raw_info = access_token.get('account/user').parsed
      end

      private

      def getHost(region)
        case region
        when "cn"
          "www.battlenet.com.cn"
        else
          "#{region}.battle.net"
        end
      end

      def getMasheryHost(region)
        case region
        when "cn"
          "api.battlenet.com.cn"
        else
          "#{region}.api.battle.net"
        end
      end
    end
  end
end
