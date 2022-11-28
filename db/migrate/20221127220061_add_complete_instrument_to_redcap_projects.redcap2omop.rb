# This migration comes from redcap2omop (originally 20210106024142)
class AddCompleteInstrumentToRedcapProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :redcap2omop_redcap_projects, :complete_instrument, :boolean, null: false, default: false
  end
end
