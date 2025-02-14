extends CharacterBody2D

class_name Player

@export var arena_time_manager: Node

@onready var collision_area_2d: Area2D = $CollisionArea2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer # the first time the TIMER is called is when there's collision with an enemy, and then on a timeout to see if there's still a collision, if not, then it will not be called again
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent
@onready var hit_random_stream_player: AudioStreamPlayer2D = $HitRandomStreamPlayer


#const MAX_SPEED: int = 125
#const ACCELERATION_SMOOTHING = 25 #I won't use this because the game just feels less responsive to me

var number_colliding_bodies = 0
var base_speed = 0

func _ready() -> void:
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	base_speed = velocity_component.max_speed
	
	collision_area_2d.body_entered.connect(on_body_entered)
	collision_area_2d.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout) # When the timer... times out, we'll call the check_damage function. The timeout is a One Shot, so no worries about it being called on an infinite loop
	health_component.health_decreased.connect(on_health_decreased)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized() # Normalizing it so the returned Vector2 is not inconsistent with diagonal movement
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	#velocity = direction * MAX_SPEED # velocity is a reserved keyword, and will move the CharacterBody2 automatically based on it

	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	#var movement_vector = Vector2.ZERO
	
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


func check_deal_damage(): 
	if number_colliding_bodies == 0 || damage_interval_timer.is_stopped() == false: # checks if there's a colliding body and the iframe timing is still running
		return
	health_component.damage(1)
	damage_interval_timer.start() # starts the iframe timer ( one shot )
	

func update_health_display():
	health_bar.value = health_component.get_health_percent() # updates the health bar with the current percent health the player has

func on_body_entered(other_body: Node2D): # We need to check if there is an enemy (OR MULTIPLE!) colliding with the player, apply damage when there is, and detect when the body leaves the player and stop applying dmg
	number_colliding_bodies += 1
	check_deal_damage()
	
	

func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	
	
func on_damage_interval_timer_timeout(): # when the timer times out, check if the player should still receive damage ( collision with enemy )
	check_deal_damage()


func on_health_decreased():
	GameEvents.emit_player_damage()
	hit_random_stream_player.play_random()


func on_health_changed():
	update_health_display()

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.5)


func on_arena_difficulty_increased(difficulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if health_regeneration_quantity > 0:
		var is_thirty_second_invertal = (difficulty % 6) == 0 # This only works because our difficulty time interval is 5 seconds...
		if is_thirty_second_invertal:
			health_component.heal(health_regeneration_quantity)
		
	
	
	
	
	
	
	
