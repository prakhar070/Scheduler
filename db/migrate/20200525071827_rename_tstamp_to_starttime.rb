class RenameTstampToStarttime < ActiveRecord::Migration[6.0]
  def change
    rename_column :interviews, :tstamp, :starttime
  end
end
