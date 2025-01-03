extends CanvasLayer

signal transitioned_halfway

var skip_emit = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func transition():
	animation_player.play("default")
	await transitioned_halfway
	skip_emit = true
	animation_player.play_backwards("default")
	
	
func transition_to_scene(scene_path: String):
	transition()
	await transitioned_halfway
	get_tree().change_scene_to_file(scene_path)

	
func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
	transitioned_halfway.emit()
	
