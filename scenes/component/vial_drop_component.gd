extends Node

@export_range(0, 1) var drop_percent: float = .75
@export var health_component: Node
@export var vial_scene: PackedScene


func _ready() -> void:
	health_component.died.connect(on_died)


func on_died(): # 'on_died' because a vial will spawn when the enemy (parent) dies
	if randf() > drop_percent: # If this random number is not above the drop percent, then it will not drop 
		return 
	
	if vial_scene == null:
		return
		
	if not owner is Node2D: # If the owner is not an Node2D (enemy), return out
		return
		
	var spawn_position = owner.global_position # Vial will spawn on the position of the enemy
	var vial_instance = vial_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer") # Gets the "Entities" Node2D in the game scene
	entities_layer.add_child(vial_instance) # Will add a vial into the Entities node, since it is the parent of the enemy
	vial_instance.global_position = spawn_position
	
