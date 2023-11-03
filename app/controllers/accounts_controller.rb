# class AccountsController < ApplicationController
# - turbo_frame or turbo_streamは使わない
class AccountsController < Base
  skip_before_action :authorize

  def index
    @accounts = Account.all
  end

  def show
  end

  def edit
  end

  def new
    @account_form = RegisterForm.new
    render action: "new"
  end

  def create
    @account_form = RegisterForm.new(account_params)

    if @account_form.valid?  # This will check validations without saving
      puts "Form is valid. Here are the parameters:"
      puts account_params.inspect # This will show what parameters are being passed to the form object
    else
      puts "Form is invalid. Here are the errors:"
      puts @account_form.errors.full_messages
    end

    # ¥ 20231012 app/services を使っている
    if @account_form.form_save
      flash[:notice] = "アカウントを新規作成しました。ログインしてください。"
      # ! recirect_toすると turbo_streamによる flash表示はされない(別で設定してある通常のflashは動く)
      # ! => create.turbo_stream.erb 自体が動かない
      redirect_to login_path

      # ! redirect_to login_path をコメントアウトすると、 create.turbo_stream.erb が動き、
      # ! ページは現在のページのまま移動しない

      # render action: 'login'

      # respond_to do |format|
      #   format.html { redirect_to login_path }
      #   format.turbo_stream
      #   # format.turbo_stream do
      #   #   render turbo_stream: turbo_stream.append('body', turbo_stream_action_redirect_to(login_path))
      #   # end
      # end
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      puts("flash: #{flash.now[:alert]}")
      # ! render しないと バリデーションメッセージは表示されない!!
      render :new, status: :unprocessable_entity
      # respond_to do |format|
      #   format.html { render :new, status: :unprocessable_entity }
      #   format.turbo_stream { render :new, status: :unprocessable_entity }
      # end
    end
  end

  def update
  end

  def destroy
  end

  private
  def account_params
    # - <input type="text" name="register_form[email]" id="register_form_email">
    params.require(:register_form).permit(:name, :name_kana, :email, :tel, :password, :description, :gender, :employment_type, :is_suspended, :is_admin, :password_confirmation)
  end
end