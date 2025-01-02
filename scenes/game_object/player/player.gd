extends CharacterBody2D

class_name Player


@onready var collision_area_2d: Area2D = $CollisionArea2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var damage_interval_timer: Timer = $DamageIntervalTimer # the first time the TIMER is called is when there's collision with an enemy, and then on a timeout to see if there's still a collision, if not, then it will not be called again
@onready var health_bar: ProgressBar = $HealthBar
@onready var abilities: Node = $Abilities





const MAX_SPEED: int = 125
#const ACCELERATION_SMOOTHING = 25 #I won't use this because the game just feels less responsive to me

var number_colliding_bodies = 0

func _ready() -> void:
	collision_area_2d.body_entered.connect(on_body_entered)
	collision_area_2d.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout) # When the timer... times out, we'll call the check_damage function. The timeout is a One Shot, so no worries about it being called on an infinite loop
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()
	

func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized() # Normalizing it so the returned Vector2 is not inconsistent with diagonal movement
	velocity = direction * MAX_SPEED # velocity is a reserved keyword, and will move the CharacterBody2 automatically based on it
	
	#velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING)) # Again, won't use acceleration because it just feels sluggish
	
	move_and_slide() # Moves the character


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


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not ability_upgrade is Ability:
		return
		
	var ability = ability_upgrade as Ability
	abilities.add_child(ability.ability_controller_scene.instantiate())
		
