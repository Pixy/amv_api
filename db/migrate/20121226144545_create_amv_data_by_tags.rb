class CreateAmvDataByTags < ActiveRecord::Migration
  def change
    create_table :amv_data_by_tags do |t|
      t.string :q
      t.text :data
      t.datetime :expires_at
      t.timestamps
    end
  end
end
