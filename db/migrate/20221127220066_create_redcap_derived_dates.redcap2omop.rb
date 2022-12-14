# This migration comes from redcap2omop (originally 20210120141828)
class CreateRedcapDerivedDates < ActiveRecord::Migration[6.0]
  def change
    create_table :redcap2omop_redcap_derived_dates do |t|
      t.string  :name,                          null: false
      t.integer :base_date_redcap_variable_id,  null: true
      t.integer :offset_redcap_variable_id,     null: false
      t.timestamps
    end
  end
end
