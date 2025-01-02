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



func apply_upgrade(upgrade: AbilityUpgrade):	
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade: # if we don't yet have this key in the dict, it will add the upgrade to the player
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1 # otherwise, it will level up the upgrade  
		
	# Will handle checking/limiting the quantity of the same upgrade that can show up
	if upgrade.max_quantity > 0: 
		var current_quantity = current_upgrades[upgrade.id]["quantity"] 
		if current_quantity == upgrade.max_quantity: # if we have have decided maximum amount of upgrades for that upgrade (e.g.: can only have 1 axe)
			upgrade_pool = upgrade_pool.filter( func (pool_upgrade): 
				return pool_upgrade.id != upgrade.id	
			)
		
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades) # calls the fact that we got an upgrade from the GameEvents singleton
	
	
func pick_upgrades(): # Basically, the upgrade pool is gonna be whatever is in the upgrade pool MINUS the upgrades that were already picked
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	for i in 2:
		if filtered_upgrades.size() == 0:
			break
		var chosen_upgrade = filtered_upgrades.pick_random() as AbilityUpgrade # Picks a random upgrade
		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter( func (upgrade): # Returns a new array. This will iterate through every single element in the 'filtered_upgrades' and will run the supplied function in every single element. If it returns true, then the element 'upgrade' stays in the filtered_upgrades
			return upgrade.id != chosen_upgrade.id # We're gonna get the chosen_upgrade, and return every upgrade in the filtered_upgrades list that does not have the same id... in other other, pick every upgrade that is NOT the same
		)
		
	return chosen_upgrades
		
	
	
	
func on_upgrade_selected(upgrade: AbilityUpgrade): # this function will be called every time the 'upgrade_selected' signal is emitted
	apply_upgrade(upgrade) # this upgrade comes all the way from the upgrade screen



func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected) # connects the instance to the 'upgrade_selected' function ( makes the instance listen to it )
