require "nkf"

# - 作成場所: sales_appointment/app/models/concerns/string_normalizer.rb
# - 値の正規化 = ある規則に従うように情報を変換すること
# - バリデーション = ある属性の値が規則に従っているかどうかを検証すること - ※本ファイルは正規化する用
# ¥ 日本語の任意のテキストをUTF-8に変換し、半角カタカナを全角に変換し、先頭または末尾の不要な空白を削除することによって正規化することを目的としている。(全角の空白も半角の空白にする)
module StringNormalizer
  extend ActiveSupport::Concern

  # -W: Assumes the input is UTF-8.
  # -w: Converts the input to UTF-8.
  # -Z1: Converts half-width Katakana characters to full-width characters.

  def normalize_as_email(text)
    NKF.nkf("-W -w -Z1", text).strip if text
  end

  # 先頭と最後尾の空白を削除 + 複数の空白のつながりを一つの半角空白に変換する
  def normalize_as_name(text)
    if text
      normalized_text = NKF.nkf("-W -w -Z1", text).strip
      normalized_text.gsub!(/\s+/, " ")  # This line replaces multiple spaces with a single space
      normalized_text
    end
  end

  def normalize_as_furigana(text)
    NKF.nkf("-W -w -Z1 --katakana", text).strip if text
  end

  def normalize_as_postal_code(text)
    NKF.nkf("-W -w -Z1", text).strip.gsub(/-/, "") if text
  end

  def normalize_as_phone_number(text)
    NKF.nkf("-W -w -Z1", text).strip if text
  end

  # ! errors.add()をつけたい場合のみ必要 - なくても uniqueness 制約にかかるため実質不要
  # Check for extra spaces in the original input
  # - validate がクラスメソッドであるため、下記全体を module ClassMethodsとすることで、
  # - 他のファイルから クラスメソッドとして直接呼び出せるようになる
  module ClassMethods
    def validate_without_extra_spaces(attr1, attr2)
      validate do
        if self.send(attr1) != self.send(attr2)
          errors.add(attr1, "から余分な空白を取り除きました =>")
        end
      end
    end
  end
end # end of module
