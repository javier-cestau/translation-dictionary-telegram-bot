class AddFirstNameToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :first_name, :string
  end
end
