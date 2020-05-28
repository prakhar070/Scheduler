class AddScheduledJobIdToJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :jobs, :scheduled_job_id, :int
  end
end
