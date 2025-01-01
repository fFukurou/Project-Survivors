extends Node

@export var MAX_RANGE = 150

@onready var timer: Timer = $Timer


@export var sword_ability: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D # Gets the player node in the game scene
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy") # Gets the enemies nodes in the game scene
	
	enemies = enemies.filter(func(enemy: Node2D): # Creates a filter function to decide what we're gonna keep !!! Also the .filter method returns a new array
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2) # returns true if the enemy is in range of the player attack
	)
	
	if enemies.size() == 0:
		return
		
		
	enemies.sort_custom(func (a: Node2D, b: Node2D): # The sort function will compare pairs (of enemies) and return true if the first argument has a shorter distance to the player than arugment 2
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		
		return a_distance < b_distance # This will basically reorganize the enemies array into 'sort by distance asc'
		
	)


	var sword_instance = sword_ability.instantiate() as Node2D
	player.get_parent().add_child(sword_instance) # get_parent will get the "Main" node, and will then add a child to it (The node sword_instance)
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4 # 'TAU' means 2PI; This will rotate the sword by a random angle, starting from the RIGHT

	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
	
