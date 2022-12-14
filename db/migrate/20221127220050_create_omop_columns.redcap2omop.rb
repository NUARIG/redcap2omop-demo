# This migration comes from redcap2omop (originally 20201111222053)
class CreateOmopColumns < ActiveRecord::Migration[6.1]
  def change
    create_table :redcap2omop_omop_columns do |t|
      t.integer :omop_table_id,   null: false
      t.string  :name,            null: false
      t.string  :data_type,       null: false
      t.string  :map_type,        null: false
      t.timestamps
      t.datetime :deleted_at,     null: true
    end
  end
end
