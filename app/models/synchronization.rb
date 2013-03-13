class Synchronization < ActiveRecord::Base
  attr_accessible :table_name, :version
end
