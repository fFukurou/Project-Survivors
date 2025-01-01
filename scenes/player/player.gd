extends CharacterBody2D

class_name Player

const MAX_SPEED: int = 200


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized() # Normalizing it so the returned Vector2 is not inconsistent with diagonal movement
	velocity = direction * MAX_SPEED # velocity is a reserved keyword, and will move the CharacterBody2 automatically based on it
	move_and_slide() # Moves the character


func get_movement_vector():
	#var movement_vector = Vector2.ZERO
	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)
