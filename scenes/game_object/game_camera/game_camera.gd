extends Camera2D

var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	acquire_target()
	#global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20)) # Smoothing the camera
	global_position = target_position
		

# Gets the (first) player node if it exists, and sets the camera target_position to the players global_position
func acquire_target():
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		var player = player_nodes[0]
		target_position = player.global_position
