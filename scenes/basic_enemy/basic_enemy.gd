extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D


const MAX_SPEED: int = 75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_2d.area_entered.connect(on_area_entered)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED # Again, velocity is a reserved keyword, and will controll movement in the CharacterBody2D
	move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Player # Gets the player node in the game scene
	if player_node != null:
		return (player_node.global_position - global_position).normalized() # Gets the direction from the enemy to the player
		
	return Vector2.ZERO # If the player is null, return this default
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	self.queue_free()
