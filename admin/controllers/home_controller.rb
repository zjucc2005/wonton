# encoding: utf-8
Wonton::Admin.controllers :home, :map => '/' do
  get :index do
    render :index
  end
end
