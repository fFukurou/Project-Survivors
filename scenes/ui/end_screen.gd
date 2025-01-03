extends CanvasLayer


@onready var panel_container: PanelContainer = %PanelContainer
@onready var continue_button: Button = %ContinueButton
@onready var quit_button: Button = %QuitButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var victory_stream_player: AudioStreamPlayer = $VictoryStreamPlayer
@onready var defeat_stream_player: AudioStreamPlayer = $DefeatStreamPlayer


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	
	get_tree().paused = true
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)



func set_defeat():
	title_label.text = "Defeat"
	description_label.text = "You lost!"
	play_jingle(true) # true means... defeat!

func play_jingle(defeat: bool = false):
	if defeat:
		defeat_stream_player.play()
	else:
		victory_stream_player.play()

func on_continue_button_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/meta_menu.tscn") # change scene to this scene



func on_quit_button_pressed():
	ScreenTransition.transition_to_scene("res://scenes/ui/main_menu.tscn")
	get_tree().paused = false
	
