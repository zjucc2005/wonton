# encoding: utf-8
Wonton::Admin.controllers :home, :map => '/' do
  get :index do
    redirect url(:products, :index)
  end

  get :test do
    request.methods.sort.map do |method|
      "<p>Request.#{method} ==> #{request.send(:"#{method}")}</p>" rescue nil
    end.join('').html_safe
  end
end
