class RenameTitileToTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :courses, :titile, :title
  end
end
