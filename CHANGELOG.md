# Changelog for Milestones

All notable changes to this project will be documented in this file.

# ––– Various ––––––––––––––––––––––––––––––––––––––––––––––––––––––
  id=
  save_id=
  name=
  unrenamable=
  type=
  canrecruit=


# ––– SideWML ––––––––––––––––––––––––––––––––––––––––––––––––––––––

side: a number
controller ai, human, null
persistent yes/no
+ save_id 
hidden yes/no shown in status table

team_name
user_team_name
side_name
defeat_condition no_leader_left/no_units_left/never/always

type: a unit_type
recruit: a list of unit_types

gold Default: 100.
income: Default: 0

village_gold
village_support
recall_cost

color
flag
flag: a custom flag animation to use instead of the default one to mark captured villages. An automatic side-coloring is applied.
    Example animation that has three frames and loops every 750ms: flag=misc/myflag-[1~3].png:750
flag_icon: a custom flag icon to indicate the side playing in the statusbar (a size of 24x16 is recommended). An automatic side-coloring is applied.

fog (black)
shroud (greyish)
share_vision: all/shroud/none


# ––– GameConfigWML –––––––––––––––––––––––––––––––––––––––––––––––
The [game_config] tag

This tag is a top level WML tag which can only be used once because it defines basic settings that are used everywhere in the game. In official versions of Wesnoth it is in game_config.cfg; values used there are labeled 'standard'. 

base_income: (standard 2) 
village_income: (standard 1) 
village_support: (standard 1) 
poison_amount: (standard 8) 
rest_heal_amount: (standard 2) 
recall_cost: (standard 20) 
kill_experience: (standard 8) 



