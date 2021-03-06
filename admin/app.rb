require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'

module Wonton
  class Admin < Padrino::Application
    use ConnectionPoolManagement
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl

    ##
    # Application configuration options
    #
    # set :raise_errors, true         # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true          # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true      # Shows a stack trace in browser (default for development)
    # set :logging, true              # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, "foo/bar"   # Location for static assets (default root/public)
    # set :reload, false              # Reload application files (default in development)
    # set :default_builder, "foo"     # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, "bar"         # Set path for I18n translations (default your_app/locales)
    # disable :sessions               # Disabled sessions by default (enable if needed)
    # disable :flash                  # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout              # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    set :admin_model, 'Account'
    set :login_page,  '/sessions/new'

    enable :sessions
    enable :store_location

    access_control.roles_for :any do |role|
      role.protect '/'
      role.allow   '/sessions'
      role.allow   '/set_locale'
    end

    access_control.roles_for :admin do |role|
      role.project_module :product_categories, '/product_categories', { :friendly_name => { :en => 'Product Categories', :zh_cn => '产品目录' } }
      role.project_module :products, '/products', { :friendly_name => { :en => 'Products', :zh_cn => '产品' } }
      role.project_module :my_mails, '/my_mails', { :friendly_name => { :en => 'Mails', :zh_cn => '邮件' } }
      role.project_module :orders, '/orders', { :friendly_name => { :en => 'Orders', :zh_cn => '订单' } }
      role.project_module :accounts, '/accounts', { :friendly_name => { :en => 'Accounts', :zh_cn => '帐号管理' } }
    end

    # Custom error management 
    error(403) { @title = 'Error 403'; render('errors/403', :layout => :error) }
    error(404) { @title = 'Error 404'; render('errors/404', :layout => :error) }
    error(500) { @title = 'Error 500'; render('errors/500', :layout => :error) }

    # Language setting, default :zh_cn
    before do
      if session['wonton.locale'].present? && I18n.available_locales.include?(:"#{session['wonton.locale']}")
        I18n.locale = :"#{session['wonton.locale']}"
      else
        I18n.locale = :zh_cn
      end
    end

    # email settings
    # info@partyali.com/1qaz@WSXServer
    # smtp.ionos.com
    # Port (for SSL Encryption) 465
    # Port (TLS/STARTTLS, alternative to SSL) 587
    set :mailer_defaults, :from => 'info@partyali.com'
    set :delivery_method, :smtp => {
                          :address              => 'smtp.ionos.com',
                          :port                 => 25,
                          :user_name            => 'info@partyali.com',
                          :password             => '1qaz@WSX',
                          :authentication       => 'plain',
                          :enable_starttls_auto => true
                        }
  end
end
