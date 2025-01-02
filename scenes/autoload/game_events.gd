extends Node

## This script will autoload globally

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


## Looks redundant. But we're relaying data to this autoload, and then this autoload will pass it down to everything else in the game
func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damage():
	player_damaged.emit()
