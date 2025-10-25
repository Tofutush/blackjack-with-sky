extends Main

func _ready() -> void:
	$Dialog.showDialog([
		"— win $1000 at Blackjack!",
		"You have $100 to start. Payout 2 to 1.",
		"Do you know how to play Blackjack?"
	])
	await $Dialog.dialog_finished
	get_tree().change_scene_to_file("res://scenes/Main/Main.tscn")
