class Base < ApplicationController
  private def current_account
    if session[:id]
      @account ||= Account.find_by(id: session[:id])
    end
  end

  helper_method :current_account

end


# Base コントローラでは、current_account メソッドは @account インスタンス変数と ||= 演算子を使用して、データベースクエリ Account.find_by(id: session[:id]) の結果を "メモする" あるいはキャッシュします。これにより、一旦@accountの値が(データベースへのクエリによって)設定されると、同じリクエスト-レスポンスサイクル中のcurrent_accountへのその後の呼び出しは、再度データベースを呼び出すことなく、単に@accountインスタンス変数から以前に取得された値を返します。

#! note:
# ページの読み込みはすべて新しいリクエストです： 別のページに移動したり、同じページを更新したりすると、新しいリクエストとレスポンスのサイクルになります。accountを含むすべてのインスタンス変数は、各サイクルの最初にリセットされます。

# サイクル内のメモ化： current_accountメソッドで@account ||= ...を使用しても、異なるリクエストやページロードにまたがって@accountが永続化されることはありません。これは、1つのリクエスト-レスポンスサイクル内で@accountの値をキャッシュします。同じサイクル内（例えば、1回のページロード内）でcurrent_accountを複数回呼び出すと、そのサイクル内でデータベースへの問い合わせが繰り返されるのを防ぐことができます。

# _header.html.erbをapplication.html.erbに含める: _header.html.erbパーシャルをapplication.html.erbに含めることは、application.html.erbレイアウトを使用するすべてのページでヘッダーがレンダリングされることを意味します。しかし、ページをロードするたびに新しいリクエストとレスポンスのサイクルが始まり、@accountのようなインスタンス変数がリセットされるという事実は変わりません。

# 別のページに移動したり、現在のページを更新したりしたときに、新しいSQLクエリを発行しなくても@accountの値が保持されているようであれば、そのような動作を引き起こす他のメカニズムやキャッシュがあるのかもしれません。しかし、あなたが示したコードでは、新しいリクエストによって@accountはリセットされ、current_accountメソッドは新しいリクエストで最初に呼び出されたときに新しいSQLクエリを発行します。