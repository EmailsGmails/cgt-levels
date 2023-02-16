require 'cgtrader_levels/version'
require 'cgtrader_levels/models/user'
require 'cgtrader_levels/models/level'
require 'cgtrader_levels/models/privilege'
require 'cgtrader_levels/models/level_privilege'

module CgtraderLevels
  autoload :User, 'cgtrader_levels/models/user'
  autoload :Level, 'cgtrader_levels/models/level'
  autoload :Privilege, 'cgtrader_levels/models/privilege'
  autoload :LevelPrivilege, 'cgtrader_levels/models/level_privilege'
end
