module CgtraderLevels
  class Privilege < ActiveRecord::Base
    has_many :level_privileges, dependent: :destroy
    has_many :levels, through: :level_privileges

    validates :value, presence: true
    validates :technical_name, presence: true, uniqueness: true

    PRIVILEGE_ELIGIBLE_ITEMS = %w(coins tax)

    def available_name
      if !PRIVILEGE_ELIGIBLE_ITEMS.include?(technical_name)
        errors.add(:technical_name, "please provide a valid technical name from available choices: #{PRIVILEGE_ELIGIBLE_ITEMS.join(', ')}")
      end
    end

    validate :available_name

    after_initialize do
      self.levels ||= []
    end
  end
end
