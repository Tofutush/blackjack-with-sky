extends SkyTalk
class_name intro
## intro!

func _ready() -> void:
	$BlackScreen.show()
	await get_tree().create_timer(2).timeout
	$WhiteScreen.show()
	super()
	await get_tree().create_timer(2).timeout
	$WhiteScreen.fadeOut()
	await $WhiteScreen.fade_finished
	$Dialog.showDialog([
			"normal@Good, you're awake.",
			"I am [b]Sky Elmwood Dazzle[/b] from the [b]Ministry of State Security[/b].",
			"You have been found guilty of treason and sentenced to death.",
			"...",
			"Well of [i]course[/i] you didn't have a trial, we don't do that here at the Ministry.",
			"We're scheduling your execution right now. The shooting grounds are a little busy so you'd have to be patient.",
			"But here's the thing. The Ministry has offered you a chance to be set free.",
			"All you need to do is —"
		])
	await $Dialog.dialog_finished
	get_tree().change_scene_to_file("res://scenes/Tutorial/tutorial.tscn")
