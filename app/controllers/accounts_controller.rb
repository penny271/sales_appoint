# class AccountsController < ApplicationController
# - turbo_frame or turbo_streamは使わない
class AccountsController < Base
  # skip_before_action :authorize

  def index
    @accounts = Account.all
    # GET /service_categories
    # @service_categories = ServiceCategory.all
    # - service_categoriesに対してページネートできるようにする
    # @service_categories = ServiceCategory.page(params[:page])

    # `ServiceCategory.ransack`でServiceCategoryに対してransackを使う
    # params[:q]には検索フォームで指定した検索条件が入る
    @search = Account.ransack(params[:q])

    # デフォルトのソートをid降順にする
    @search.sorts = "id desc" if @search.sorts.empty?

    # `@search.result`で検索結果となる@service_categoriesを取得する
    # 検索結果に対してはkaminariのpageメソッドをチェーンできる
    @accounts = @search.result.page(params[:page]).per(params[:per_page] || Kaminari.config.default_per_page)
  end

  def show
  end

  def new
    @account_form = RegisterForm.new
    render action: "new"
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    if @account.update(account_update_params)
      flash[:notice] = "更新しました。"
      puts("flash[:success]: #{flash[:success]}")
      redirect_to action: :edit
    else
      puts @account.errors.full_messages
      flash[:alert] = "入力に誤りがあります。"
      # ! flashを出す出さないに関わらず、 status: は必須 ないと
      #! turbo.es2017-esm.js:2406 Error: Form responses must redirect to another location が発生する
      render "edit", status: :unprocessable_entity
    end
  end

  def create
    @account_form = RegisterForm.new(account_new_params)

    if @account_form.valid? # This will check validations without saving
      puts "Form is valid. Here are the parameters:"
      puts account_new_params.inspect # This will show what parameters are being passed to the form object
    else
      puts "Form is invalid. Here are the errors:"
      puts @account_form.errors.full_messages
    end

    # ¥ 20231012 app/services を使っている
    if @account_form.form_save
      if current_account
        flash[:notice] = "アカウントを新規作成しました。"
        # ! recirect_toすると turbo_streamによる flash表示はされない(別で設定してある通常のflashは動く)
        # ! => create.turbo_stream.erb 自体が動かない
        redirect_to new_account_path
      else
        flash[:notice] = "アカウントを新規作成しました。ログインしてください。"
        # ! recirect_toすると turbo_streamによる flash表示はされない(別で設定してある通常のflashは動く)
        # ! => create.turbo_stream.erb 自体が動かない
        redirect_to login_path
      end

      # ! redirect_to login_path をコメントアウトすると、 create.turbo_stream.erb が動き、
      # ! ページは現在のページのまま移動しない
    else
      flash.now[:alert] = "入力項目に誤りがあります。"
      puts("flash: #{flash.now[:alert]}")
      # ! render しないと バリデーションメッセージは表示されない!!
      render :new, status: :unprocessable_entity
    end
    puts("通常 create完了")
  end

  def destroy
    @account = Account.find(params[:id])
    if @account.destroy
      flash[:notice] = "Object was successfully deleted."
      # redirect_to objects_url
    else
      flash[:alert] = "Something went wrong"
      # redirect_to objects_url
    end
  end

  # ///////////////////////////////////////////////////////////////
  # * パスワード変更処理
  # ///////////////////////////////////////////////////////////////
  def change_password
    @account = Account.find(params[:id])
  end

  # PATCH /accounts/:id/update_password
  def update_password
    @account = Account.find(params[:id])
    # additional logic for authorization and security checks

    if @account.update(account_password_params)
      # handle a successful password change
      flash[:notice] = "パスワードを変更しました。"
      redirect_to root_path
    else
      flash.now[:alert] = "パスワードを変更できませんでした。"
      render :change_password
    end
  end

  private

  def account_new_params
    # - <input type="text" name="register_form[email]" id="register_form_email">
    params.require(:register_form).permit(:name, :name_kana, :email, :tel, :password, :description, :gender, :employment_type, :is_suspended, :is_admin, :password_confirmation)
  end

  # ¥ passwordはupdateしない
  def account_update_params
    # - <input type="text" name="register_form[email]" id="register_form_email">
    # params.require(:account).permit(:name, :name_kana, :email, :tel, :password, :description, :gender, :employment_type, :is_suspended, :is_admin, :password_confirmation)
    params.require(:account).permit(:name, :name_kana, :email, :tel, :description, :gender, :employment_type, :is_suspended, :is_admin)
  end

  # ¥ passwordの変更用
  def account_password_params
    # - <input type="text" name="register_form[email]" id="register_form_email">
    # params.require(:account).permit(:name, :name_kana, :email, :tel, :password, :description, :gender, :employment_type, :is_suspended, :is_admin, :password_confirmation)
    params.require(:account).permit(:password, :password_confirmation)
  end
end
