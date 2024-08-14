# Waiter
Have your Roblox hierarchy instances served to you succinctly and safely!

## Setup (Roblox)
1. Set up a Wally project.
2. Add Waiter as a dependency in your `Wally.toml` file.
3. Run `wally install`.

🎉 Congratulations! You've installed Waiter.

# API
Valid search modes:
- "Tag"
- "ClassName"
```lua
-- Return nil if none are found
Waiter.getChild(origin, query, searchMode)
Waiter.getSibling(origin, query, searchMode)
Waiter.getDescendant(origin, query, searchMode)
Waiter.getAncestor(origin, query, searchMode)

-- Return empty table if none are found
Waiter.getChildren(origin, query, searchMode)
Waiter.getSiblings(origin, query, searchMode)
Waiter.getDescendants(origin, query, searchMode)
Waiter.getAncestors(origin, query, searchMode)
```
