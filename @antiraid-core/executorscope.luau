--- The scope of the kv executor. 
--- `this_guild` means the executor is scoped to the current guild.
--- `owner_guild` means the executor is scoped to the guild that owns the template on the template shop (for non shop templates, this is equivalent to `this_guild`).
---@enum ExecutorScope
---@variant this_guild string The executor is scoped to the current guild.
---@variant owner_guild string The executor is scoped to the guild that owns the template on the template shop.
export type ExecutorScope = "this_guild" | "owner_guild"

return {}