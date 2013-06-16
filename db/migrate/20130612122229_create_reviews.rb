class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :video
      t.integer :rating
      t.text :content

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :video_id
  end
end
