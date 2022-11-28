# This migration comes from redcap2omop (originally 20210625113006)
class AddDeletedInNextDataDictionaryToRedcapVariables < ActiveRecord::Migration[6.1]
  def change
    add_column :redcap2omop_redcap_variables, :deleted_in_next_data_dictionary, :boolean, null: true
  end
end
