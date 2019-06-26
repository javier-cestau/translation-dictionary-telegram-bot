class AddWebsiteSourceToChat < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :website_source, :string, default: 'wordreference.com'
  end
end
