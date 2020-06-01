class ChangeDataTypeForScheduledJobId < ActiveRecord::Migration[6.0]
  def change
    change_table :jobs do |t|
      t.change :scheduled_job_id, :string
    end
  end
end
