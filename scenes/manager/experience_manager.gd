extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 3

var current_experience = 0
var current_level = 1
var target_experience = 1

func _ready() -> void:
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected) # Connects the on_experience_vial_collected function with the signal from GameEvents

func increment_experience(number: float): # Icrements the experience
	current_experience = min(current_experience + number, target_experience) # Clamps the exp so we don't go over
	experience_updated.emit(current_experience, target_experience) # Emits the fact that we collected EXP, to whoever is listening
	if current_experience == target_experience: # If we fill up the bar, basically
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH # Increases the XP requirement, per level basis
		current_experience = 0 # Resets the exp bar
		experience_updated.emit(current_experience, target_experience) # Well now the current exp is 0, so the signal is emitted
		level_up.emit(current_level) # Emits that the player leveled up
	
func on_experience_vial_collected(number: float): # When this event is called, it will increment the experience
	increment_experience(number)
