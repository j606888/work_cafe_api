class EnableExtension < ActiveRecord::Migration[7.0]
  def change
    enable_extension "cube"
    enable_extension "earthdistance"
  end
end
