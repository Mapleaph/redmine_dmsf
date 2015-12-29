class AddDownloadableFieldToDmsfFolders < ActiveRecord::Migration
	def change
		add_column :dmsf_folders, :downloadable, :integer, :null => true
	end
end
