class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.references :user
      t.references :video
      t.integer :position      
      t.timestamps
    end
  end
end
