# This migration comes from redcap2omop (originally 20210106173755)
class AddApiImportToRedcapProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :redcap2omop_redcap_projects, :api_import, :boolean
  end
end
