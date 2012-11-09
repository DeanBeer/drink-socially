module NRB
  module Untappd
    class Checkin < APIObject

      def self.attrs
        [ :beer, :brewery, :checkin_comment, :checkin_id, :comments,
          :created_at, :media, :rating_score, :source, :toasts, :user, :venue ]
      end
      setup_instance_variables

    end
  end
end
