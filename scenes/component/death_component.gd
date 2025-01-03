extends Node2D

@export var health_component: Node
@export var sprite: Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var hit_random_audio_player_component: AudioStreamPlayer2D = $HitRandomAudioPlayerComponent


func _ready() -> void:
	gpu_particles_2d.texture = sprite.texture # as long as we supply the sprite, it should keep in sync with the enemy visual
	health_component.died.connect(on_died)
	
	
func on_died():
	if owner == null || not owner is Node2D:
		return
	
	var spawn_position = owner.global_position
	
	var entities = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities.add_child(self)
	
	global_position = spawn_position
	animation_player.play("default")
	hit_random_audio_player_component.play_random()
	
	
