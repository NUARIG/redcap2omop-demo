# This migration comes from redcap2omop (originally 20201112113748)
class CreateRedcapVariableMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :redcap2omop_redcap_variable_maps do |t|
      t.integer :redcap_variable_id,   null: false
      t.integer :concept_id,           null: true
      t.integer :omop_column_id,       null: true
      t.timestamps
      t.datetime :deleted_at,     null: true
    end
  end
end
