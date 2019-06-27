ActiveAdmin.register Word do 
  config.sort_order = "times_searched_desc"
  
  index do
    column :text
    column :times_searched
    column :language_source
  end
  
end
  