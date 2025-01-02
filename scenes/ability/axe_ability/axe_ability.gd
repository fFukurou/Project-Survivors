extends Node2D

const MAX_RADIUS = 100 # how far away the AXE can be from the player

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var base_rotation = Vector2.RIGHT


func _ready() -> void:
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween() # we're gonna animate the axe using tweens, tweens are good because we can use variables
	tween.tween_method(tween_method, 0.0, 2.0, 3) # goes from 0, to 2, over X seconds... and while tweening, call the 'tween_method' passed 
	tween.tween_callback(queue_free) # when the tween is done, it's gonna invoke the queue_free() function
	
	
func tween_method(rotations: float): # we are getting the 'rotations' over time, or, over the duration of the tween
	var percent = rotations / 2
	var current_radius = rotations * MAX_RADIUS
	var current_direction = base_rotation.rotated(rotations * TAU) # 'TAU' is 2PI
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return 
	
		
	global_position = player.global_position + (current_direction * current_radius) # axe will rotate from the player position, and will offset from that position by the (current_direction * current_radius) 
