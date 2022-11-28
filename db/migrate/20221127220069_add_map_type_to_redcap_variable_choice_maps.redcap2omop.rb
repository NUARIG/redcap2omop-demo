# This migration comes from redcap2omop (originally 20210204125255)
class AddMapTypeToRedcapVariableChoiceMaps < ActiveRecord::Migration[6.0]
  def change
    add_column :redcap2omop_redcap_variable_choice_maps, :map_type, :string, null: false
  end
end
