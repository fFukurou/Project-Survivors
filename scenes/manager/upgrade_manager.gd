extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}

## FLOW: we chose which upgrade we want to show in the upgrade screen
## instantiate the upgrade screen and add it as a child
## we tell it "okay here are the upgrade we wanna show"
## then on 'upgrade_screen.gd' we iterate through the supplied array and create a visual card for each upgrade
## it emits a signal that we catch, saying which upgrade was selected, and we add it into our current upgrade dictionary
## basically, we send the data, and expect to receive data





func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
	var chosen_upgrade = upgrade_pool.pick_random() as AbilityUpgrade # Picks a random upgrade
	if chosen_upgrade == null:
		return

	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades([chosen_upgrade] as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected) # connects the instance to the 'upgrade_selected' function ( makes the instance listen to it )

func apply_upgrade(upgrade: AbilityUpgrade):	
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade: # if we don't yet have this key in the dict, it will add the upgrade to the player
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1 # otherwise, it will level up the upgrade  
		
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades) # calls the fact that we got an upgrade from the GameEvents singleton
	
	
func on_upgrade_selected(upgrade: AbilityUpgrade): # this function will be called every time the 'upgrade_selected' signal is emitted
	apply_upgrade(upgrade) # this upgrade comes all the way from the upgrade screen
