extends Node

@export var MAX_RANGE = 150

@onready var timer: Timer = $Timer


@export var sword_ability: PackedScene

var base_damage = 5
var additional_damage_percent = 1
var base_wait_time # We'e storing the base wait time for the ability so that we can change it later through upgrades


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D # Gets the player node in the game scene
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy") # Gets the enemies nodes in the game scene
	
	enemies = enemies.filter(func(enemy: Node2D): # Creates a filter function to decide what we're gonna keep !!! Also the .filter method returns a new array
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2) # returns true if the enemy is in range of the player attack
	)
	
	if enemies.size() == 0:
		return
		
		
	enemies.sort_custom(func (a: Node2D, b: Node2D): # The sort function will compare pairs (of enemies) and return true if the first argument has a shorter distance to the player than arugment 2
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		
		return a_distance < b_distance # This will basically reorganize the enemies array into 'sort by distance asc'
		
	)


	var sword_instance = sword_ability.instantiate() as SwordAbility
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer") # Will get the Foreground Node2D in the game scene
	foreground_layer.add_child(sword_instance) # will get the Foreground node, and will then add a child to it (The node sword_instance)
	sword_instance.hitbox_component.damage = base_damage * additional_damage_percent
	
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4 # 'TAU' means 2PI; This will rotate the sword by a random angle, starting from the RIGHT

	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
	

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary): # When we get an upgrade to this ability (sword), what do we do? This
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1 # How much of these sword_rate upgrades do we have? We multiply it by 0.1
		timer.wait_time = base_wait_time * (1 - percent_reduction) # settings the new cooldown time for the ability. If it was 1 upgrade, 10%, 2 --> 20% and so on
		timer.start() # if we don't do this, it won't reset the remaining time to the new wait_time
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + (current_upgrades["sword_damage"]["quantity"] * 0.15)
