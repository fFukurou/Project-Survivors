extends CanvasLayer

@export var arena_time_manager: Node

@onready var label = %Label


func _process(delta: float) -> void:
	if arena_time_manager == null:
		return
	var time_elapsed = arena_time_manager.get_time_elapsed() # This will get the time elapsed of the arena
	label.text = format_seconds_to_string(time_elapsed)
	

func format_seconds_to_string(seconds: float):
	var minutes = floor(seconds / 60) # Extracts the "minute" part of the timer from the raw time float variable
	var remaining_seconds = seconds - (minutes * 60) # Extracts the "seconds" part of the full raw timer
	return str(minutes) + ":" + "%02d" % floor(remaining_seconds) # Formats the time for the label
