# This migration comes from redcap2omop (originally 20201221161302)
class AddInsertPersonToRedcapProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :redcap2omop_redcap_projects, :insert_person, :boolean
  end
end
