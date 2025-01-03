extends Node

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INVERTAL = 5	

@export var end_screen_scene: PackedScene

@onready var timer: Timer = $Timer

var arena_difficulty = 0 # var that will hold the 'difficulty' progress over time


func _ready():
	timer.timeout.connect(on_timer_timeout)


func _process(delta: float) -> void:
	var next_time_target = timer.wait_time - ((arena_difficulty + 1) * DIFFICULTY_INVERTAL) # 'what time needs to be remaining to increment the arena difficulty'
	if timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout(): # When this times out, it means the player won ( survived long enough ) 
	#var end_screen_instance = end_screen_scene.instantiate() # creates a victory screen instance
	#add_child(end_screen_instance) 
	#end_screen_instance.play_jingle()
	#MetaProgression.save()
	pass
