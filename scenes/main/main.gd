extends Node

@export var end_screen_scene: PackedScene

@onready var player: Player = %Player

func _ready() -> void:
	player.health_component.died.connect(on_player_died)
	
	
	
func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate() # instantiates the end screen "deafeat" as a node
	add_child(end_screen_instance) # adds the defeat screen into as a child of Main --> Also the "_ready" method is gonna be called as part of the add_child
	end_screen_instance.set_defeat()
	
	
