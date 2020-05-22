class CreateInterviews < ActiveRecord::Migration[6.0]
  def change
    create_table :interviews do |t|
      t.datetime :tstamp
      t.integer :interviewer_id

      t.timestamps
    end
  end
end
