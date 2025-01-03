extends CharacterBody2D


@onready var visuals: Node2D = $Visuals
@onready var velocity_component: Node = $VelocityComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hit_random_audio_player_component: AudioStreamPlayer2D = $HitRandomAudioPlayerComponent

func _ready() -> void:
	hurtbox_component.hit.connect(on_hit)

func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)

#func get_direction_to_player():
	#var player_node = get_tree().get_first_node_in_group("player") as Player # Gets the player node in the game scene
	#if player_node != null:
		#return (player_node.global_position - global_position).normalized() # Gets the direction from the enemy to the player
		
	#return Vector2.ZERO # If the player is null, return this default

func on_hit():
	hit_random_audio_player_component.play_random()
