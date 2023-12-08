# Waiter
Have your Roblox hierarchy instances served to you succinctly and safely!
- Want to get a descendant of `MainMenu` with a class name of `Button` tagged "play_button"?  
  `Waiter.get.descendant(MainMenu, {Tag = "play_button", ClassName = "Button"})`
- Want to wait for a child of `Workspace` named "Jonathon"?  
  `Waiter.waitFor.child(workspace, {Name = "Jonathon"})`
- Want to collect all the important elements of a menu into one table?  
  `Waiter.collect.descendants(Menu, {RespawnButton = {Tag = "respawn_button}, MainMenuButton = {Tag = "main_menu_button"})`

## Setup (Roblox)
1. Set up a Wally project.
2. Add Waiter as a dependency in your `Wally.toml` file.
3. Run `wally install`.

🎉 Congratulations! You've installed Waiter.
