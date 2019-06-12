class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.string :telegram_chat_id
      t.string :language_source
      t.string :language_translation

      t.timestamps
    end
  end
end
