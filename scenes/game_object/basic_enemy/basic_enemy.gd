extends CharacterBody2D


@onready var health_component: HealthComponent = $HealthComponent


const MAX_SPEED: int = 45



func _process(delta: float) -> void:
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED # Again, velocity is a reserved keyword, and will controll movement in the CharacterBody2D
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Player # Gets the player node in the game scene
	if player_node != null:
		return (player_node.global_position - global_position).normalized() # Gets the direction from the enemy to the player
		
	return Vector2.ZERO # If the player is null, return this default
