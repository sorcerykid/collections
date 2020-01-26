--------------------------------------------------------
-- Minetest :: Basic Collections Mod v1.0 (collections)
--
-- See README.txt for licensing and other information.
-- Copyright (c) 2020, Leslie E. Krause
--
-- ./games/minetest_game/mods/xcommands/init.lua
--------------------------------------------------------

local can_inherit = true		-- allow inheritence of protected properties

----------------------------
-- StaticSet Class
----------------------------

function StaticSet( list )
	local data = { }
	local self = { length = 0 }

	for i, v in ipairs( list ) do
		-- repeated values are okay in a membership set
       		data[ v ] = true
	end
	self.length = #list

	self.iterate = function ( )
		local k
		return function ( )
			-- use parens so only return key
			k = ( next( data, k ) )
			return k
		end
	end

	self.elems = setmetatable( { }, {
		__index = function ( t, k )
			return data[ k ] ~= nil
		end,
		__newindex = function ( )
			error( "Attempt to modify read-only collection." )
		end
	} )

	self.exists = function ( elem )
		return data[ elem ] ~= nil
	end

	if can_inherit then
		return self, data
	else
		return self
	end
end

----------------------------
-- Set Class
----------------------------

function Set( list )
	local self, data = StaticSet( list or { } )	-- inherit from base class

	self.elems = setmetatable( { }, {
		__index = function ( t, k )
			return data[ k ] ~= nil
		end,
		__newindex = function ( t, k, v )
			if v ~= true and v ~= false then error( "Invalid assignment in collection." ) end

			if v then
				self.insert( k )
			else
				self.delete( k )
			end
		end
	} )

	self.insert = function ( val )
		if not data[ val ] then
			data[ val ] = true
			self.length = self.length + 1
		end
	end
	self.remove = function ( val )
		if data[ val ] then
			data[ val ] = nil
			self.length = self.length - 1
		end
	end
	self.clear = function ( )
		data = { }
		self.length = 0
	end

	return self
end

----------------------------
-- StaticEnum Class
----------------------------

function StaticEnum( list )
	local data = list
	local idata = { }
	local self = { length = 0 }

	for i, v in ipairs( list ) do
		if idata[ v ] then
			error( "Duplicate values not permitted in collection." )
		end
       		idata[ v ] = i
	end
	self.length = #list

	self.concat = function ( sep )
		return table.concat( data, sep )
	end
	self.iterate = function ( )
		-- TODO: iterate every key-value pair, even if array has holes
		return ipairs( data )
	end

	self.elems = setmetatable( { }, {
		__index = function ( t, k )
			return idata[ k ] ~= nil
		end,
		__newindex = function ( ) error( "Attempt to modify read-only collection." ) end
	} )
	self.values = setmetatable( { }, {
		__index = data,
		__newindex = function ( ) error( "Attempt to modify read-only collection." ) end
	} )
	self.keys = setmetatable( { }, {
		__index = idata,
		__newindex = function ( ) error( "Attempt to modify read-only collection." ) end
	} )
	self.has_key = function ( key )
		return data[ key ] ~= nil
	end
	self.has_value = function ( val )
		return idata[ val ] ~= nil
	end
	self.value_of = function ( key )
		return data[ key ]
	end
	self.key_of = function ( val )
		return idata[ val ]
	end

	if can_inherit then
		return self, data, idata
	else
		return self
	end
end

----------------------------
-- Enum Class
----------------------------

function Enum( list )
	local self, data, idata = StaticEnum( list or { } )	-- inherit from base class

	self.values = setmetatable( { }, {
		__index = data,
		__newindex = function ( t, k, v )
			if v ~= nil then
				self.assign( k, v )
			else
				self.remove( k )
			end
		end
	} )
	self.keys = setmetatable( { }, {
		__index = idata,
		__newindex = function ( t, k, v )
			if v ~= nil then
				self.reassign( k, v )
			else
				self.unassign( k )
			end
		end
	} )
	self.assign = function ( key, val )
		if tonumber( key ) == nil or val == nil or data[ key ] == nil or idata[ val ] then
			error( "Invalid assignment in collection.", 2 )
		end
		idata[ data[ key ] ] = nil	-- remove old index
		data[ key ] = val
		idata[ val ] = key
	end
	self.reassign = function ( val, key )
		if tonumber( key ) == nil or val == nil or data[ key ] ~= nil or not idata[ val ] then
			error( "Invalid assignment in collection.", 2 )
		end
		data[ idata[ val ] ] = nil	-- remove old value
		data[ key ] = val
		idata[ val ] = key
	end
	self.insert = function ( key, val )
		if tonumber( key ) == nil or val == nil or data[ key ] ~= nil or idata[ val ] then
			error( "Attempt to reassign or unassign value in collection.", 2 )
		end
		data[ key ] = val
		idata[ val ] = key
		self.length = self.length + 1
	end
	self.remove = function ( key )
		if data[ key ] ~= nil then
			idata[ data[ key ] ] = nil
			data[ key ] = nil
			self.length = self.length - 1
		end
	end
	self.unassign = function ( val )
		if idata[ val ] ~= nil then
			data[ idata[ val ] ] = nil
			idata[ val ] = nil
			self.length = self.length - 1
		end
	end
	self.clear = function ( )
		data = { }
		idata = { }
		self.length = 0
	end

	return self
end

----------------------------
-- StaticDict Class
----------------------------

function StaticDict( hash )
	local data = hash
	local rdata = { }
	local self = { length = 0 }

	for k, v in pairs( hash ) do
		if rdata[ v ] ~= nil then
			error( "Duplicate values not permitted in collection." )
		end
       		rdata[ v ] = k
		self.length = self.length + 1
	end

	self.iterate = function ( )
		return pairs( data )
	end
	self.elems = setmetatable( { }, {
		__index = function ( t, k )
			return rdata[ k ] ~= nil
		end,
		__newindex = function ( ) error( "Attempt to modify read-only collection." ) end
	} )
	self.values = setmetatable( { }, {
		__index = data,
		__newindex = function ( ) error( "Attempt to modify read-only collection." ) end
	} )
	self.keys = setmetatable( { }, {
		__index = rdata,
		__newindex = function ( ) error( "Attempt to modify read-only collections." ) end
	} )
	self.has_key = function ( key )
		return data[ key ] ~= nil
	end
	self.has_value = function ( val )
		return rdata[ val ] ~= nil
	end
	self.value_of = function ( key )
		return data[ key ]
	end
	self.key_of = function ( val )
		return rdata[ val ]
	end

	if can_inherit then
		return self, data, rdata
	else
		return self
	end
end

----------------------------
-- Dict Class
----------------------------

function Dict( hash )
	local self, data, rdata = StaticDict( hash or { } )	-- inherit from base class

	self.values = setmetatable( { }, {
		__index = data,
		__newindex = function ( t, k, v )
			self.assign_key( k, v )
		end
	} )
	self.keys = setmetatable( { }, {
		__index = rdata,
		__newindex = function ( t, k, v )
			self.assign_value( k, v )
		end
	} )

	self.assign = function ( key, val )
		if val == nil or data[ key ] == nil or rdata[ val ] ~= nil then
			error( "Invalid assignment in collection.", 2 )
		end
		rdata[ data[ key ] ] = nil	-- remove old key
		data[ key ] = val
		rdata[ val ] = key
	end
	self.reassign = function ( val, key )
		if val == nil or data[ key ] ~= nil or rdata[ val ] == nil then
			error( "Invalid reassignment in collection.", 2 )
		end
		data[ rdata[ val ] ] = nil	-- remove old value
		data[ key ] = val
		rdata[ val ] = key
	end
	self.insert = function ( key, val )
		if val == nil or data[ key ] ~= nil or rdata[ val ] ~= nil then
			-- existing keys and values are immutable on insert
			error( "Attempt to reassign or unassign value in collection." )
		end
		rdata[ val ] = key
		data[ key ] = val
		self.length = self.length + 1
	end
	self.remove = function ( key )
		if data[ key ] ~= nil then
			rdata[ data[ key ] ] = nil
			data[ key ] = nil
			self.length = self.length - 1
		end
	end
	self.unassign = function ( val )
		if rdata[ val ] ~= nil then
			data[ rdata[ val ] ] = nil
			rdata[ val ] = nil
			self.length = self.length - 1
		end
	end
	self.clear = function ( )
		data = { }
		rdata = { }
		self.length = 0
	end

	return self
end

----------------------------
-- Flags Class
----------------------------

function Flags( hash )
	local data = hash
	local self = { }

	for k, v in pairs( hash ) do
		if v ~= true and v ~= false then
			error( "Non-boolean values not permitted in collection." )
		end
	end

	self.states = setmetatable( { }, {
		__index = data,
		__newindex = function ( ) error( "Attempt to modify read-only collection." ) end
	} )

	self.enable = function ( key, val )
		if key == nil or data[ key ] == nil or val ~= true and val ~= false then
			error( "Invalid assignment in collection.", 2 )
		end
		data[ key ] = val
	end
	self.disable = function ( key, val )
		if key == nil or data[ key ] == nil or val ~= true and val ~= false then
			error( "Invalid assignment in collection.", 2 )
		end
		data[ key ] = not val
	end
	self.toggle = function ( key )
		if key == nil or data[ key ] == nil then
			error( "Invalid assignment in collection.", 2 )
		end
		data[ key ] = not data[ key ]
	end
	self.reset = function ( val )
		if val ~= true and val ~= false then
			error( "Invalid assignment in collection.", 2 )
		end
		for k, v in pairs( data ) do
			data[ k ] = val
		end
	end

	return self
end
