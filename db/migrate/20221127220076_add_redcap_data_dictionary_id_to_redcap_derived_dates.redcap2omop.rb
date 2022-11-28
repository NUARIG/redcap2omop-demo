# This migration comes from redcap2omop (originally 20210629200156)
class AddRedcapDataDictionaryIdToRedcapDerivedDates < ActiveRecord::Migration[6.1]
  def change
    add_column :redcap2omop_redcap_derived_dates, :redcap_data_dictionary_id, :integer, null: false
  end
end
