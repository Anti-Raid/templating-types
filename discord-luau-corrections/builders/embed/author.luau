--!nocheck
-- -- Does not type under new type solver yet

--[[
	Implementation of discords Author object as a Luau builder.	

	https://discord.com/developers/docs/resources/message#embed-object-embed-author-structure
]]

local Author = {}

Author.Prototype = {}
Author.Interface = {}

--[[
	Set the image url for this embed.
]]
function Author.Prototype.setName(self: Author, name: string): Author
	assert(#name <= 256, "Name must be less than 256 characters")
	assert(#name > 1, "Name must be greater than 1 characters")

	self.name = name

	return self
end

--[[
	Set the image height for this embed.
]]
function Author.Prototype.setUrl(self: Author, url: string): Author
	self.url = url

	return self
end

--[[
	Set the image height for this embed.
]]
function Author.Prototype.setIcon(self: Author, iconUrl: string, proxyIconUrl: string?): Author
	self.iconUrl = iconUrl
	self.proxyIconUrl = proxyIconUrl

	return self
end

--[[
	Responsible for building the Author JSON that can be parsed by the Discord API.
]]
function Author.Prototype.build(self: Author): JSON
	assert(self.name, `Author must have a name`)

	return {
		name = self.name,
		url = self.url,
		icon_url = self.iconUrl,
		proxy_icon_url = self.proxyIconUrl,
	}
end

--[[
	Responsible for creating a new Author.

	```lua
	
	```
]]
function Author.Interface.new(resource: {
	name: string?,
	url: string?,
	iconUrl: string?,
	proxyIconUrl: string?,
}?): Author
	local self = setmetatable({} :: Author, {
		__index = Author.Prototype,
	})

	if resource then
		if resource.name then
			self:setName(resource.name)
		end

		if resource.url then
			self:setUrl(resource.url)
		end

		if resource.iconUrl then
			self:setIcon(resource.iconUrl, resource.proxyIconUrl)
		end
	end

	return self
end

export type Author = typeof(Author.Prototype) & {
	name: string?,
	url: string?,
	iconUrl: string?,
	proxyIconUrl: string?,
}

export type JSON = typeof(Author.Prototype.build({} :: any))

return Author.Interface
