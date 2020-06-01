class CreateJoinTableUsersInterviews < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :interviews do |t|
      
    end
  end
end
