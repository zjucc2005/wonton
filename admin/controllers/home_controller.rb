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

  get :select_locale do
    if params[:locale].present? && I18n.available_locales.include?(:"#{params[:locale]}")
      session['wonton.locale'] = params[:locale]
    end
    redirect params[:back_url] || url(:home, :index)
  end
end
