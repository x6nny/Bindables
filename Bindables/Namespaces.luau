--> Class
local Namespace = {}
Namespace.__index = Namespace

--> Types
export type self = {
	callBacks : {
		[number] : () -> ()
	},
	Subscribe : (self, callBack : () -> ()) -> () -> (),
	Fired : (self) -> (),
	Destroy : (self) -> (),
}

--> Constructor
function Namespace.new()
	local self = setmetatable({}, Namespace)
	self.callBacks = {}
	return self :: self
end

--> Methods
function Namespace:Subscribe(callBack : () -> ()) : () -> ()
	self = self :: self
	table.insert(self.callBacks, callBack)
	return function()
		for index, call in pairs(self.callBacks) do
			if call == callBack then
				self.callBacks[index] = nil
				break
			end
		end
	end
end

function Namespace:Fired(...)
	self = self :: self
	for _, v in pairs(self.callBacks) do
		v(...)
	end
end

function Namespace:Destroy()
	self = self :: self
	table.clear(self)
end

--> return
return Namespace