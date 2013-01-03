class CreateAmvDataBySkus < ActiveRecord::Migration
  def change
    create_table :amv_data_by_skus do |t|
      t.string :q
      t.text :data
      t.datetime :expires_at

      t.timestamps
    end
  end
end
