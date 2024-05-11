# Waiter
Have your Roblox hierarchy instances served to you succinctly and safely!

## Setup (Roblox)
1. Set up a Wally project.
2. Add Waiter as a dependency in your `Wally.toml` file.
3. Run `wally install`.

🎉 Congratulations! You've installed Waiter.

# API
## get
The `get` module retrieves an instance, or set of instances, and returns them to you.
```lua
-- Return nil if none are found
get.child(origin, tag)
get.sibling(origin, tag)
get.descendant(origin, tag)
get.ancestor(origin, tag)

-- Return empty table if none are found
get.children(origin, tag)
get.siblings(origin, tag)
get.descendants(origin, tag)
get.ancestors(origin, tag)
```
