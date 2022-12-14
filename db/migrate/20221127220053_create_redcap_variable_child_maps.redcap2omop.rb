# This migration comes from redcap2omop (originally 20201112153947)
class CreateRedcapVariableChildMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :redcap2omop_redcap_variable_child_maps do |t|
      t.integer :redcap_variable_id,          null: true
      t.integer :parentable_id,               null: false
      t.string  :parentable_type,             null: false
      t.integer :omop_column_id,              null: true
      t.timestamps
      t.datetime :deleted_at,     null: true
    end
  end
end
