require 'drink-socially/api_object'
require 'drink-socially/checkin'
module NRB
  module Untappd
    class User < APIObject

      def self.attrs
        [ :account_type, :bio, :checkins, :contact, :date_joined, :first_name,
          :id, :is_private, :last_name, :location, :media, :recent_brews,
          :relationship, :settings, :stats, :uid, :untappd_url, :url,
          :user_avatar, :user_name ]
      end

      setup_instance_variables

    end
  end
end
