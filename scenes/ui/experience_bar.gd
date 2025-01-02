extends CanvasLayer

@export var experience_manager: Node
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)
	
	
func on_experience_updated(current_exp: float, target_exp: float):
	var percent = current_exp / target_exp # Gets the percentage
	progress_bar.value = percent # updates the value of the progress bar with the percent
