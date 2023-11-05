Rails.application.routes.draw do
  get 'accounts/index'
  get 'accounts/show'
  get 'accounts/edit'
  get 'accounts/new'
  get 'accounts/create'
  get 'accounts/update'
  get 'accounts/destroy'
  get 'commodity_categories/index'
  # root to: 'admin/top#index'
  root to: 'top#index'

  # get "login" => "sessions#new", as: :login
  # post "session" => "sessions#create", as: :session
  # delete "session" => "sessions#destroy"

  # get 'login', to: 'sessions#new', as: :login
  # post 'session', to: 'sessions#create', as: :session
  # delete 'session', to: 'sessions#destroy'

  scope controller: :sessions do
    get 'login', action: :new, as: :login
    # post 'session', action: :create, as: :session
    # delete 'session', action: :destroy
    # - 20231014 第一引数が urlにあたる
    resource :session, only: [:create, :destroy]
  end

  #^ 青木 ★要更新 - 20231014 /appointments/new => /apo/new  のように変更可能!
  resources :appointments, path: "appo"

  #^ 青木 ★要更新 - 20231014 /appointments/new => /apo/new  のように変更可能!
  resources :service_categories, path: "service_categories"

  resources :commodity_categories, path: "commodity_categories"

  resources :accounts, path: "accounts" do
    member do
      get 'change_password', to: 'accounts#change_password' # for displaying the password change form
      patch 'update_password'  # for submitting the password change form
    end
  end

  # 検証用
  get 'html/scroll_x'



  # # - 20231013 上記の書き換え 厳密には Prefix と URI-Patternが変わる
  # * Prefix: login => login_session   |   Uri-Pattern: /login  =>   /session/login
  # resource :session, only: [:new, :create, :destroy], controller: :sessions do
  #   get 'login', action: :new, as: :login
  # end

  # root "top#index"
  # get 'top/index', to: 'top#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  namespace :admin do
    root "top#index"
  end

  namespace :user do
    root "top#index"
  end
end

# - 20231013 - ルーティングに名前を与えるメリット:
# * シンボルでURLパスを表現することには、主に2つのメリットがあります。1つは、プログラマが名前を書き間違えたときにエラーになることです。たとえば、URLパスを文字列で指定した場合"/stuff/login" と書き間違えても、Railsはエラーを出しません。私たちが実際にリンクをクリックし「404 Not Found」のページを見て、はじめてミスに気づくことになります。しかし、URLパスにシンボル:stuff_login を指定した場合は、リンク元のページを表示しただけでエラーが発生します。間違いはなるべく早く発見されるべきですので、これは大きな利点です。

# ¥ 名前を与えることで login_path / login_url といったヘルパーメソッドが定義される
# ¥ => ヘルパーメソッドを用いるとurlにクエリパラメータを付与できる
# * 前者はURLのパス部分を返し、後者はURL全体を返します。　ヘルパーメソッド login_path を用いれば、次のようにしてERBテンプレートにリンクを埋め込むことができます。
# - <%= link_to "ログイン", login_path %>
# login_path の部分は:login とも書けるのでヘルパーメソッドの出番はなさそうにも思えますが、ヘルパーメソッドを用いるとURLにクエリパラメータを付加することが可能になります。
# - <%= link_to "ログイン", login_path(tracking: "001") %>
# この場合、次のようなHTMLコードが生成されます。
# - <a href="/login?tracking=001">ログイン</a>

