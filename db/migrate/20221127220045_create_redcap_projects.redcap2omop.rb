# This migration comes from redcap2omop (originally 20201111190603)
class CreateRedcapProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :redcap2omop_redcap_projects do |t|
      t.integer :project_id,  null: false
      t.string  :name,        null: false
      t.string  :api_token,   null: false
      t.string :export_table_name, null: false
      t.timestamps
      t.datetime :deleted_at, null: true
    end
  end
end
