class CreateTeamMemberships < ActiveRecord::Migration
  def change
    create_table :team_memberships, id: false do |t|
      t.integer :project_id
      t.integer :user_id
      t.boolean :owner

      t.timestamps
    end
    add_index :team_memberships, :owner
  end
end
