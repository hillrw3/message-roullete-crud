class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string  :comment
      t.integer :message_id
    end
  end

  def down
    # add reverse migration code here
  end
end
