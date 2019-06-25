ActiveAdmin.register Chat do
  
    index do
      column :telegram_chat_id
      column :language_source
      column :language_translation
      column :first_name
    end
  
end
  