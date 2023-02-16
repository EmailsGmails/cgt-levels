require 'cgtrader_levels/models/privilege'
require 'cgtrader_levels/models/level'
require 'cgtrader_levels/models/level_privilege'

module CgtraderLevels
  class User < ActiveRecord::Base
    belongs_to :level
    attr_reader :level

    def level
      CgtraderLevels::Level.where('experience <= ?', reputation).order(experience: :desc).first
    end

    after_initialize do
      self.reputation ||= 0

      matching_level = level

      if matching_level
        self.level_id = matching_level.id
        @level = matching_level
      end
    end

    before_save :set_new_level

    private

    def set_new_level
      matching_level = level

      if matching_level
        self.level_id = matching_level.id
        set_level_privileges(matching_level.privileges) if !matching_level.privileges.blank?
        @level = matching_level
      end
    end

    def set_level_privileges(privileges)
      privileges.each { |privilege|
        if privilege.valid?
          self.send("#{privilege.technical_name}=", self.send(privilege.technical_name) + privilege.value)
        end
      }
    end
  end
end
