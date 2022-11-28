# This migration comes from redcap2omop (originally 20210106174309)
class ChangeColumnNullRedcapProjectsApiToken < ActiveRecord::Migration[6.1]
  def change
    change_column_null :redcap2omop_redcap_projects, :api_token, true
  end
end
