# This migration comes from redcap2omop (originally 20201110125426)
class CreateOmopCdm < ActiveRecord::Migration[6.1]
  def change
    Redcap2omop::Setup.compile_omop_tables
    Redcap2omop::Setup.compile_omop_table_extensions
  end
end
