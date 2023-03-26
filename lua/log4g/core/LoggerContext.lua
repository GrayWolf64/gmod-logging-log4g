--- The LoggerContext, which is the anchor for the logging system.
-- Subclassing `LifeCycle`.
-- It maintains a list of all the loggers requested by applications and a reference to the Configuration.
-- @classmod LoggerContext
-- @license Apache License 2.0
-- @copyright GrayWolf64
Log4g.Core.LoggerContext = Log4g.Core.LoggerContext or {}
local LifeCycle = Log4g.Core.LifeCycle.GetClass()
local LoggerContext = LifeCycle:subclass("LoggerContext")
local GetDefaultConfiguration = Log4g.Core.Config.GetDefaultConfiguration
local istable, isstring = istable, isstring
--- This is where LoggerContexts are stored.
-- This is done to prevent the rapid changes in logging system's global table from polluting it.
-- @local
-- @table INSTANCES
local INSTANCES = INSTANCES or {}

function LoggerContext:Initialize(name)
    LifeCycle.Initialize(self)
    self:SetPrivateField("logger", {})
    self.name = name
end

function LoggerContext:SetConfigurationSource(src)
    self:SetPrivateField("source", src)
end

--- Gets where this LoggerContext is declared.
-- @return table source
function LoggerContext:GetConfigurationSource()
    return self:GetPrivateField("source")
end

--- Gets a Logger from the Context.
-- @name The name of the Logger
function LoggerContext:GetLogger(name)
    if not isstring(name) then return end

    return self:GetPrivateField("logger")[name]
end

--- Gets a table of the current loggers.
-- @return table loggers
function LoggerContext:GetLoggers()
    return self:GetPrivateField("logger")
end

--- Returns the current Configuration of the LoggerContext.
-- @return object configuration
function LoggerContext:GetConfiguration()
    return self:GetPrivateField("configuration")
end

--- Sets the Configuration to be used.
-- @param config Configuration
function LoggerContext:SetConfiguration(config)
    if not istable(config) then return end
    if self:GetConfiguration() == config then return end
    config:SetContext(self.name)
    self:SetPrivateField("configuration", config)
end

function LoggerContext:__tostring()
    return "LoggerContext: [name:" .. self.name .. "]"
end

--- Terminate the LoggerContext.
function LoggerContext:Terminate()
    self:DestroyPrivateTable()
    INSTANCES[self.name] = nil
end

--- Determines if the specified Logger exists.
-- @param The name of the Logger to check
-- @return bool haslogger
function LoggerContext:HasLogger(name)
    if not isstring(name) then return end
    if self:GetLogger(name) then return true end

    return false
end

function Log4g.Core.LoggerContext.GetAll()
    return INSTANCES
end

--- Get the LoggerContext with the right name.
-- @param name String name
-- @return object loggercontext
function Log4g.Core.LoggerContext.Get(name)
    if not isstring(name) then return end
    if INSTANCES[name] then return INSTANCES[name] end
end

--- Register a LoggerContext.
-- @param name The name of the LoggerContext
-- @param withconfig Whether or not come with a DefaultConfiguration, leaving it nil will make it come with one
-- @return object loggercontext
function Log4g.Core.LoggerContext.Register(name, withconfig)
    if INSTANCES[name] then return INSTANCES[name] end
    INSTANCES[name] = LoggerContext(name)

    if withconfig or withconfig == nil then
        INSTANCES[name]:SetConfiguration(GetDefaultConfiguration())
    end

    return INSTANCES[name]
end

function Log4g.Core.LoggerContext.GetClass()
    return LoggerContext
end