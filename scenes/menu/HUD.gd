extends CanvasLayer

signal start_game
signal change_volume(volume)

@onready var message = $MenuContainer/Message
@onready var message_timer = $MessageTimer
@onready var buttons_container = $MenuContainer/ButtonsContainer
@onready var score_label = $ScoreLabel
@onready var volume_slider = get_node("%VolumeSlider")

func set_volume(percent):
	volume_slider.value = percent
	_on_volume_changed(percent)
	
func show_message(text):
	message.text = text
	message.show
	message_timer.start()

func show_game_over():
	show_message("Game Over")
	await message_timer.timeout
	
	message.text = "Dodge the Creeps!"
	message.show()
	
	await get_tree().create_timer(1.0).timeout
	buttons_container.show()
	
func update_score(score):
	score_label.text = str(score)
	
func _on_message_timer_timeout():
	message.hide()

func _on_start_button_pressed():
	buttons_container.hide()
	start_game.emit()

func _on_volume_changed(percent):
	change_volume.emit(linear_to_db(percent))

func _on_options_button_pressed():
	$MenuContainer.hide()
	$OptionsContainer.show()

func _on_goback_button_pressed():
	$MenuContainer.show()
	$OptionsContainer.hide()
