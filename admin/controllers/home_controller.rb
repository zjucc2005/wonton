# encoding: utf-8
Wonton::Admin.controllers :home, :map => '/' do
  get :index do
    render :index
  end

  get :test do
    current_locale.to_s
  end
end
