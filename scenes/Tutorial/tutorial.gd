extends Main

func _ready() -> void:
	$ContinueButton.hide()
	$Dialog.showDialog([
		"— win $1000 at Blackjack!",
		"You have $100 to start.",
		"Rules mostly standard, look them up if you don't know. Some are configurable in the settings.",
		"Other than that, have fun!"
	])
	await $Dialog.dialog_finished
	get_tree().change_scene_to_file("res://scenes/Main/Main.tscn")
