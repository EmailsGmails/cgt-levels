module CgtraderLevels
  class Level < ActiveRecord::Base
    has_many :level_privileges, dependent: :destroy
    has_many :privileges, through: :level_privileges

    after_initialize do
      self.privileges ||= []
    end
  end
end
