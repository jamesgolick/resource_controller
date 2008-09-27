class AddPersonelIdToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :personel_id, :integer
  end

  def self.down
    remove_column :photos, :personel_id
  end
end
