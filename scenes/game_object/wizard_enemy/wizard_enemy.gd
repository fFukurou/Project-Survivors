extends CharacterBody2D

@onready var velocity_component: Node = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals: Node2D = $Visuals
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hit_random_audio_player_component: AudioStreamPlayer2D = $HitRandomAudioPlayerComponent

var is_moving = false

func _ready() -> void:
	hurtbox_component.hit.connect(on_hit)

func _process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
		
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
func set_is_moving(moving: bool):
	is_moving = moving

func on_hit():
	hit_random_audio_player_component.play_random()
