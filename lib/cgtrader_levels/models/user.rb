class CgtraderLevels::User < ActiveRecord::Base
  attr_reader :level

  after_initialize do
    self.reputation = 0

    matching_level = CgtraderLevels::Level.where(experience: reputation).first

    if matching_level
      self.level_id = matching_level.id
      @level = matching_level
    end
  end

  after_update :set_new_level

  private

  def set_new_level
    levels = CgtraderLevels::Level.all.order(:experience).reverse
    matching_level = levels.find { |level| self.reputation >= level.experience }

    if matching_level
      self.level_id = matching_level.id
      @level = matching_level
    end
  end
end
