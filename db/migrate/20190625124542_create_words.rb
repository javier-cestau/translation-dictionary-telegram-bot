class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :text
      t.string :language_source
      t.integer :times_searched, default: 0

      t.timestamps
    end
  end
end
