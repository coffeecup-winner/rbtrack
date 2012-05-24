class AddPriorityToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :priority, :int
    add_index :issues, :priority
  end
end
