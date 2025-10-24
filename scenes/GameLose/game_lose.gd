extends SkyTalk
class_name GameLose
## played when you lose the game

func _ready() -> void:
	super()
	print('super finish')
	$Dialog.showDialog([
		"normal@You lost too much money.",
		"Your death sentence will carry out as planned.",
		"It was nice meeting you. Maybe in another life we could've been friends.",
		"Don't take it personally, will you?",
		"Anyway my job here is done. I still have a class to go to. See you!"
	])
	await $Dialog.dialog_finished
	$BlackScreen.fadeIn()
	await $BlackScreen.fade_finished
	get_tree().change_scene_to_file("res://scenes/Start/Start.tscn")
