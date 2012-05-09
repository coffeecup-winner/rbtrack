class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :assignee_id
      t.string :subject
      t.text :description
      t.integer :status

      t.timestamps
    end
    add_index :issues, :project_id
    add_index :issues, :user_id
    add_index :issues, :assignee_id
  end
end
