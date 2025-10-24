extends SkyTalk
class_name GameWin
## played when you win the game

func _ready() -> void:
	super()
	$Dialog.showDialog([
		"You won!",
		"Good game!",
		"Your execution is scheduled for this afternoon.",
		"...",
		"Oh, setting you [i]free[/i]?",
		"Come on.",
		"A thousand bucks isn't enough to bail yourself out.",
		"You don't think your life is worth more than that?",
		"Hehe. Your fault for getting your hopes up.",
		"Anyway my job here is done. I still have a class to go to. See you!"
	])
	await $Dialog.dialog_finished
	$BlackScreen.fadeIn()
	await $BlackScreen.fade_finished
	get_tree().change_scene_to_file("res://scenes/Start/Start.tscn")
