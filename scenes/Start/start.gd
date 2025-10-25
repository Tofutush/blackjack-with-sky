extends Control
## literally startscreen

func _ready() -> void:
	$Button.grab_focus()
	$BlackScreen.fadeOut()

func _on_button_pressed() -> void:
	$BlackScreen.fadeIn()
	await $BlackScreen.fade_finished
	get_tree().change_scene_to_file("res://scenes/Intro/intro.tscn")
