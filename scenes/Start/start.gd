extends Control
## literally startscreen

func _ready() -> void:
	$BlackScreen.fadeOut()
	$SettingsContainer.hide()

func _on_button_pressed() -> void:
	$NewGameWarning.show()

func _on_continue_button_pressed() -> void:
	$BlackScreen.fadeIn()
	await $BlackScreen.fade_finished
	get_tree().change_scene_to_file("res://scenes/Main/Main.tscn")

func _on_settings_button_pressed() -> void:
	$SettingsContainer.show()

func _on_yes_button_pressed() -> void:
	$BlackScreen.fadeIn()
	await $BlackScreen.fade_finished
	get_tree().change_scene_to_file("res://scenes/Intro/intro.tscn")

func _on_no_button_pressed() -> void:
	$NewGameWarning.hide()
