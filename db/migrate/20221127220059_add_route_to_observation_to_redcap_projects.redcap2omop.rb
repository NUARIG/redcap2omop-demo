# This migration comes from redcap2omop (originally 20201217201225)
class AddRouteToObservationToRedcapProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :redcap2omop_redcap_projects, :route_to_observation, :boolean
  end
end
