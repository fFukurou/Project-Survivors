extends Node

@export var axe_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var damage = 10

func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)
	
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground = get_tree().get_first_node_in_group("foreground_layer") as Node2D # grabs the foreground node from the main scene
	if foreground == null:
		return
		
		

	var axe_instance = axe_ability_scene.instantiate() as Node2D # instantiates the Axe scene
	foreground.add_child(axe_instance) # Adds it to the Foreground layer in the main game scene
	axe_instance.global_position = player.global_position # Spawns the Axe "on top" of the player
	axe_instance.hitbox_component.damage = damage
