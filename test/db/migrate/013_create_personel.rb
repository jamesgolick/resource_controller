class CreatePersonel < ActiveRecord::Migration
  def self.up
    create_table :personel, :force => true do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :personel
  end
end
