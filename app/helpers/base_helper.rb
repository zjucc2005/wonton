# encoding: utf-8
module Wonton
  class App
    module BaseHelper

      def app
        ::Wonton::App
      end

      def current_locale
        I18n.locale
      end

      ##
      # resource_params_permit(:account, %w[email nickname password password_confirmation])
      def resource_params_permit(model, permit_fields=[])
        if Hash === params[model]
          params[model].select{|key, val| permit_fields.include?(key) }
        else
          Hash.new
        end
      end

      ##
      # get random name, timestamp(12) + random string(8)
      def get_random_name
        "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{Account.new_token(8)}"
      end

      # spec 在运行测试代码时, 忽略远程调用
      def test_mode
        Padrino.env == :test && params[:spec] == 'yes'
      end

    end

    helpers BaseHelper
  end
end