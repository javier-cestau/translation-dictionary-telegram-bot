class AddLanguageTranslationToWords < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :language_translation, :string
  end
end
