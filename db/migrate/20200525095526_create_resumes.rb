class CreateResumes < ActiveRecord::Migration[6.0]
  def change
    create_table :resumes do |t|
      t.references :interview
      t.timestamps
    end
  end
end
