# encoding: utf-8
Wonton::App.controllers :home, :map => '/' do

  # homepage
  get :index do
    render :index
  end

  get :company do
    render :company
  end

  get :contact do
    render :contact
  end

  get :set_locale do
    if params[:locale].present? && I18n.available_locales.include?(:"#{params[:locale]}")
      session['wonton.locale'] = params[:locale]
    end
    redirect params[:back_url] || url(:home, :index)
  end

  # 处理 ckeditor 文件上传
  post :ckupload do
    @callback = params[:CKEditorFuncNum]
    @url = ''
    @error = ''
    begin
      file      = params[:upload]
      ext       = File.extname file[:filename]
      rand_name = "#{get_random_name}#{ext}"  # 文件存放用名字
      dir_path  = 'public/ckupload'
      file_path = "#{dir_path}/#{rand_name}"  # 文件存放路径
      FileUtils.mkdir_p dir_path unless Dir.exist? dir_path
      File.open(file_path, 'wb') do |f|
        f.write(File.open(file[:tempfile].path).read)
      end
      @url = Padrino.env == :development ?
        "/ckupload/#{rand_name}" : "#{request.base_url}/ckupload/#{rand_name}" # 文件访问url
    rescue Exception => e
      @error = e.message
    end

    res = "<script>window.parent.CKEDITOR.tools.callFunction(#{@callback}, '#{@url}', '#{@error}');</script>"
    res.html_safe
  end

end