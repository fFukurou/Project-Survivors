extends Node

@export var end_screen_scene: PackedScene

var pause_menu_scene = preload("res://scenes/ui/pause_menu.tscn")

@onready var player: Player = %Player

func _ready() -> void:
	player.health_component.died.connect(on_player_died)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		get_tree().root.set_input_as_handled()
		

func on_player_died():
	var end_screen_instance = end_screen_scene.instantiate() # instantiates the end screen "deafeat" as a node
	add_child(end_screen_instance) # adds the defeat screen into as a child of Main --> Also the "_ready" method is gonna be called as part of the add_child
	end_screen_instance.set_defeat()
	MetaProgression.save()
	
