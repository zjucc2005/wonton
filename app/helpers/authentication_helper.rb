# encoding: utf-8
module Wonton
  class App
    module AuthenticationHelper

      def current_account
        @current_account ||= login_from_session
      end

      def set_current_account(account=nil)
        session[settings.session_id] = account ? account.id : nil
        @current_account = account
      end

      def login_from_session
        Account.find_by_id(session[settings.session_id]) if defined? Account
      end

      def logged_in?
        !current_account.nil?
      end

    end

    helpers AuthenticationHelper
  end
end