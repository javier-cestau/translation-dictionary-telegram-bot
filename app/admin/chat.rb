ActiveAdmin.register Chat do 

  index do
    column :telegram_chat_id
    column :language_source
    column :language_translation
    column :website_source
    column :first_name
  end

end
  