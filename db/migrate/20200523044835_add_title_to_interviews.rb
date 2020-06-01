class AddTitleToInterviews < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews, :title, :string
  end
end
