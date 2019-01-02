# encoding: utf-8
Wonton::App.controllers :home, :map => '/' do

  get :index do
    @title = '宁波江北汇园包装礼品厂'
    render :index
  end

  get :en do
    @title = 'Ningbo Jiangbei Huiyuan Gifts and Packing Manufactory'
    render :index_en
  end

end