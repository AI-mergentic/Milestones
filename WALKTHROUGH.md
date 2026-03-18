# Milestones Template Optimization Walkthrough

I have optimized the "Milestones" template to significantly speed up your campaign development process. You can now manage character dramatispersonae and recruitment from a single Lua file, and your WML scenarios will automatically reflect these changes.

## Key Enhancements

### 1. Centralized Role Management
- **File**: [part-I/campaign/lua/dramatispersonae.lua](file:///home/verwalter/.local/share/wesnoth/1.19/data/add-ons/Milestones/part-I/campaign/lua/dramatispersonae.lua)
- **Utility**: You can now define all your protagonists and antagonists in this one file. Change a leader's `type`, `name`, or `recruit` list here, and it updates **globally** across all your scenarios.

### 2. Deep Lua-WML Synchronization
- **Dynamic Variables**: The template now automatically exports your Lua dramatispersonae into WML variables.
- **Example**: In WML, you can use `$milestones.dramatispersonae.protagonistes.id` for dialogue or recruitment.
- **Improved Macros**: I've refactored `{PROTAGONISTES}`, `{ANTAGONISTES}`, etc., to reference these dynamic variables.

### 3. Streamlined Scenarios
- **Reduced Boilerplate**: The new `{MILESTONES_INIT}` macro replaces messy `[lua]` events in your scenarios.
- **Gold-Standard Template**: I created [part-I/campaign/scenarios/00_Template.cfg](file:///home/verwalter/.local/share/wesnoth/1.19/data/add-ons/Milestones/part-I/campaign/scenarios/00_Template.cfg). Use this as a starting point for every new scenario you build. It includes examples of dialogue, recruitment, and victory events using the new system.

## How to use this for new campaigns

1.  **Open [dramatispersonae.lua](file:///home/verwalter/.local/share/wesnoth/1.19/data/add-ons/Milestones/part-I/campaign/lua/dramatispersonae.lua)**: Define your characters.
2.  **Copy [00_Template.cfg](file:///home/verwalter/.local/share/wesnoth/1.19/data/add-ons/Milestones/part-I/campaign/scenarios/00_Template.cfg)**: Rename it to `02_My_Next_Battle.cfg`.
3.  **Adjust the Map**: Change the `map_data` to point to your new `.map` file.
4.  **Edit Dialogue**: Use the speaker IDs defined in [dramatispersonae.lua](file:///home/verwalter/.local/share/wesnoth/1.19/data/add-ons/Milestones/part-I/campaign/lua/dramatispersonae.lua) (e.g., `speaker=$milestones.dramatispersonae.protagonistes.id`).

## Verification Results
- [x] **Lua Engine**: Initialization verified.
- [x] **WML Variables**: Successfully exported using recursive logic (Fixed "WML scalar" error).
- [x] **Character Spawning**: Leaders now correctly pull stats from the Lua table.
- [x] **Recruitment**: Recruit lists are now dynamic.

Your template is now a professional-grade starting point for any Battle for Wesnoth campaign!
