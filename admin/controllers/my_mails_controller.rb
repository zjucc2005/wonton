# encoding: utf-8
Wonton::Admin.controllers :my_mails, :map => 'my_mails' do

  get :index do
    @title = 'My mails'
    query = MyMail.all
    @my_mails = query.order(:created_at => :desc).paginate(:page => params[:page], :per_page => 10)
    render :index
  end

  get :new do
    @title = pat(:new_title, :model => 'my_mail')
    @my_mail = MyMail.new(status: 'new')
    render :new
  end

  post :create do
    @my_mail = MyMail.new(my_mail_params.merge(author: current_account))
    @my_mail.to_emails = params[:my_mail][:to_emails].split(/;|；/).map(&:strip)
    if @my_mail.save
      @title = pat(:create_title, :model => "my_mail #{@my_mail.id}")
      flash[:success] = pat(:create_success, :model => 'my_mail')
      if params[:save_and_send]
        # create_mail_tasks here
        begin
          ActiveRecord::Base.transaction do
            @my_mail.deliver
          end
          flash[:success] = pat(:send_success, :model => 'my_mail')
        rescue Exception => e
          flash[:error] = "Error: #{e.message}"
        end

        redirect(url(:my_mails, :index))
      else
        flash[:success] = pat(:save_success, :model => 'my_mail')
        redirect(url(:my_mails, :edit, :id => @my_mail.id))
      end
    else
      @title = pat(:create_title, :model => 'my_mail')
      flash.now[:error] = pat(:create_error, :model => 'my_mail')
      render :new
    end
  end

  get :edit, :map => ':id/edit' do
    @title = pat(:edit_title, :model => 'my_mail')
    load_my_mail
    render :edit
  end

  put :update, :map => ':id/update' do
    load_my_mail
    unless @my_mail.can_edit?
      flash[:error] = 'invalid operation'
      redirect(url(:my_mails, :index))
      return
    end

    if @my_mail.update(my_mail_params)
      @my_mail.to_emails = params[:my_mail][:to_emails].split(/;|；/).map(&:strip)
      @my_mail.save!

      if params[:save_and_send]

        # create_mail_tasks here
        begin
          ActiveRecord::Base.transaction do
            @my_mail.deliver
          end
          flash[:success] = pat(:send_success, :model => 'my_mail')
        rescue Exception => e
          flash[:error] = "Error: #{e.message}"
        end

        redirect(url(:my_mails, :index))
      else
        flash[:success] = pat(:update_success, :model => 'my_mail', :id =>  "#{params[:id]}")
        redirect(url(:my_mails, :edit, :id => @my_mail.id))
      end
    else
      flash.now[:error] = pat(:update_error, :model => 'my_mail')
      render :edit
    end
  end

  delete :destroy, :map => ':id/destroy' do
    load_my_mail
    if @my_mail.destroy
      flash[:success] = pat(:delete_success, :model => 'my_mail', :id => "#{params[:id]}")
    else
      flash[:error] = pat(:delete_error, :model => 'my_mail')
    end
    redirect url(:my_mails, :index)
  end

end