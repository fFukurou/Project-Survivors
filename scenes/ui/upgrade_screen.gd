extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = %CardContainer


## The reason for nesting this into multiple functions is that each 'thing' should have its own functionality
## The card is just reponsible for detecting that it has been clicked and displaying the data
## The upgrade screen is responsible for displaying all the abilities that were supplied and or chosen AND telling us when an ability was selected


func _ready() -> void:
	get_tree().paused = true

func set_ability_upgrades(upgrades: Array[AbilityUpgrade]):
	for upgrade in upgrades:
		var card_instance = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade)) # the 'selected' signal does not set any arguments by itself, but binding the 'upgrade' var into it, we're able to pass it into the function we're calling
		
		
func on_upgrade_selected(upgrade: AbilityUpgrade): # every time we receive the 'connect' signal, this function will be called too
	upgrade_selected.emit(upgrade) # emits the selected upgrade
	get_tree().paused = false
	queue_free()
