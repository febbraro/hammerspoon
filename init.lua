package.path = package.path .. ';plugins/?.lua'

hs.logger.defaultLogLevel = 'debug'
logger = hs.logger.new('hs-ff')

local PLUGINS={
  "hangout"
}


for i,plugin in ipairs(PLUGINS) do
  logger.df("Loading plugin %s", plugin)
  -- First, load the plugin
  mod = require(plugin)
  -- If it returns a table (like a proper module should), then
  -- we may be able to access additional functionality
  if type(mod) == "table" then
    -- If it has an init() function, call it
    if type(mod.init) == "function" then
      logger.i(string.format("Initializing plugin %s", plugin))
      mod.init(logger)
    end
  end
end
