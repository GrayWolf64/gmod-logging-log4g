--- The Layout.
-- @classmod Layout
local Layout = include("log4g/core/impl/Class.lua"):Extend()

function Layout:New(name, func)
    self.name = name or ""
    self.func = func or function() end
end

--- Register a Layout.
-- If the Layout with the same name already exists, its function will be overrode.
-- @param name The name of the Layout
-- @param func The function of the layouting process
-- @return object layout
function Log4g.Registrars.RegisterLayout(name, func)
    local layout = Layout(name, func)
    table.insert(Log4g.Core.Layouts, layout)

    return layout
end

local PatternLayout = include("log4g/core/server/layout/PatternLayout.lua")
Log4g.Core.Layouts.PatternLayout = Layout("PatternLayout", PatternLayout)