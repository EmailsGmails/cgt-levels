module CgtraderLevels
  class LevelPrivilege < ActiveRecord::Base
    belongs_to :level, class_name: 'Level'
    belongs_to :privilege, class_name: 'Privilege'
  end
end
