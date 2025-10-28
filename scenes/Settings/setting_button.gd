extends Control

@onready var panel_container: PanelContainer = $PanelContainer

var shown := false

func _ready() -> void:
	panel_container.hide()

func _on_toggled() -> void:
	print('toggled')
	if shown:
		panel_container.hide()
		shown = false
	else:
		panel_container.show()
		shown = true

func _on_close_button_pressed() -> void:
	panel_container.hide()
	shown = false

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Start/Start.tscn")
