extends Node

@onready var timer: Timer = $Timer

const SPAWN_RADIUS = 380


@export var basic_enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
	
func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
		
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU)) # Randomize the direction the next enemy is gonna spawn 
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var enemy = basic_enemy_scene.instantiate() as Node2D # Creates the enemy
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy) # Adds the enemy as a child of the 'Entities' scene...
	enemy.global_position = spawn_position # Spawns the enemy in the spawn position we calculated
	
	
