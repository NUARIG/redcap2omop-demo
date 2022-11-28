# This migration comes from redcap2omop (originally 20210114174018)
class AddMapTypeToRedcapVariableChildMaps < ActiveRecord::Migration[6.0]
  def change
    add_column :redcap2omop_redcap_variable_child_maps, :map_type, :string, null: false
  end
end
