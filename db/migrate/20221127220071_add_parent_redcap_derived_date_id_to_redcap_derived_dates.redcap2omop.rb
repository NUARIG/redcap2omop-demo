# This migration comes from redcap2omop (originally 20210215193000)
class AddParentRedcapDerivedDateIdToRedcapDerivedDates < ActiveRecord::Migration[6.0]
  def change
    add_column :redcap2omop_redcap_derived_dates, :parent_redcap_derived_date_id, :integer, null: true
  end
end


