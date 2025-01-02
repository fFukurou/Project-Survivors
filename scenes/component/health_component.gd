extends Node
class_name HealthComponent

signal died
signal health_changed


@export var max_health: float = 10
var current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0) # This ensures the health won't go below 0; max() takes the maximum between two numbers; one is health after the damage, and the other is 0.
	health_changed.emit()
	Callable(check_death).call_deferred() # Will call the function in the next idle frame


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		died.emit() # Emits the fact that we died to whoever is listening
		owner.queue_free() # 'owner' gets the parent of the node at the time... in this case, probably either the enemy of the player
	
