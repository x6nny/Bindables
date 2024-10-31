--! strict
local Namespaces = require(script.Namespaces)

--> Types
export type NAME_SPACES = {
	[string] : typeof(Namespaces.new())
}

export type Namespaces = {
	defineNamespace : (name : string) -> typeof(Namespaces.new()),
	fire : (nameSpace : string) -> (),
	removeNamespace : (nameSpace : string) -> ()
}

--> Name space storage
local NAME_SPACES : NAME_SPACES = {}

--> Class
local Class = {}

--> Private
local function GetNamespace(Name : string) : typeof(Namespaces.new())
	return NAME_SPACES[Name]
end

--> Public
function Class.defineNamespace(name : string) : typeof(Namespaces.new())
	if NAME_SPACES[name] then return end
	NAME_SPACES[name] = Namespaces.new()
	return NAME_SPACES[name]
end

function Class.fire(nameSpace : string, ...)
	local Namespace = GetNamespace(nameSpace)
	if Namespace == nil then 
		local Attempts = 0
		repeat
			Namespace = GetNamespace(nameSpace)
			task.wait(0.1)
			Attempts += 1
		until Attempts >= 10
	end
	if Namespace == nil then return end
	Namespace:Fired(...)
end

function Class.removeNamespace(name : string)
	if NAME_SPACES[name] ~= nil then
		NAME_SPACES[name]:Destroy()
		NAME_SPACES[name] = nil
	end
end

--> return
return Class