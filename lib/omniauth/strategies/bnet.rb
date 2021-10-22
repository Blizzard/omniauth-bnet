# frozen_string_literal: true

require 'omniauth-oauth2'
require 'base64'

module OmniAuth
  module Strategies
    # OmniAuth Bnet strategy
    class Bnet < OmniAuth::Strategies::OAuth2
      option :region, 'us'
      option :client_options, {
        scope: 'wow.profile sc2.profile'
      }

      def client
        host = resolve_host options.region

        # Setup urls based on region option
        set_client_option :authorize_url, "https://#{host}/oauth/authorize"
        set_client_option :token_url, "https://#{host}/oauth/token"
        set_client_option :site, "https://#{host}/"

        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            params[v.to_sym] = request.params[v] if request.params[v]
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

        @raw_info = access_token.get('oauth/userinfo').parsed
      end

      private

      def callback_url
        full_host + script_name + callback_path
      end

      def resolve_host(region)
        return 'www.battlenet.com.cn' if region.eql? 'cn'

        "#{region}.battle.net"
      end

      def set_client_option(key, default_value)
        return if options.client_options.has_key(key)

        options.client_options[key] = default_value
      end
    end
  end
end
