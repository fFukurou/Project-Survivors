extends Node


const SPAWN_RADIUS = 380


@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node


@onready var timer: Timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new()
var number_to_spawn = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_table.add_item(basic_enemy_scene, 10)
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
	
func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO # Assign initial spawn position
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU)) # Randomize the direction the next enemy is gonna spawn 
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20
		
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1) # checking terrain layer for collision
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		
		if result.is_empty():
			break # if a spawn position is valid, we return early out of the loop
		else:
			random_direction = random_direction.rotated(deg_to_rad(90)) # otherwise, shift the raycast 90 degrees to check if there's a free space anywhere else
			
			
	return spawn_position
	
	
	
	
func on_timer_timeout() -> void:
	timer.start() # we start the time manually so we can change the timer 
	
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	
	for i in number_to_spawn:
		var enemy_scene = enemy_table.pick_item()
		var enemy = enemy_scene.instantiate() as Node2D # Creates the enemy
		
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child(enemy) # Adds the enemy as a child of the 'Entities' scene...
		enemy.global_position = get_spawn_position() # Spawns the enemy in the spawn position we calculated
	
	
func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1 / 12) * arena_difficulty  # 5 seconds per difficulty increase, and there's 12 "5 seconds segments" in a minute
	time_off = min(time_off, 0.7)
	#print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 12:
		enemy_table.add_item( bat_enemy_scene, 7 )
	elif arena_difficulty == 24:
		enemy_table.add_item( wizard_enemy_scene, 13 )
	
	if (arena_difficulty % 6) == 0:
		number_to_spawn += 1
		
	
	
	
	
