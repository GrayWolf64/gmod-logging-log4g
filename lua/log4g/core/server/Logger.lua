--- The Logger.
-- @classmod Logger
Log4g.Logger = Log4g.Logger or {}
Log4g.Inst._Loggers = Log4g.Inst._Loggers or {}
local Logger = include("log4g/core/impl/Class.lua"):Extend()

function Logger:New(name, loggerconfig)
    self.name = name or ""
    self.loggerconfig = loggerconfig or {}
end

--- Delete the Logger.
function Logger:Delete()
    Log4g.Inst._Loggers[self.name] = nil
end

--- Register a Logger.
-- If the Logger with the same name already exists, its loggerconfig will be overrode.
-- @param name The name of the Logger
-- @param loggerconfig The Loggerconfig
-- @return object logger
function Log4g.Logger.RegisterLogger(name, loggerconfig)
    if name == "" or loggerconfig == {} then return end

    if not HasKey(Log4g.Inst._Loggers, name) then
        local logger = Logger(name, loggerconfig)
        Log4g.Inst._Loggers[name] = logger

        return logger
    else
        Log4g.Inst._Loggers[name].loggerconfig = loggerconfig

        return Log4g.Inst._Loggers[name]
    end
end