class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column :comment_id, :integer
      t.column :stars, :integer
    end
  end

  def self.down
    drop_table :ratings
  end
end
