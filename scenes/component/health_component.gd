extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased


@export var max_health: float = 10
var current_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
		
	Callable(check_death).call_deferred() # Will call the function in the next idle frame


func heal(heal_amount: int):
	damage(-heal_amount)


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)

func check_death():
	if current_health == 0:
		died.emit() # Emits the fact that we died to whoever is listening
		owner.queue_free() # 'owner' gets the parent of the node at the time... in this case, probably either the enemy of the player
	
