extends SkyTalk
class_name intro
## intro!

func _ready() -> void:
	$Dialog.linkSprite(self)
	$BlackScreen.queue_free()
	$WhiteScreen.show()
	$IntroBlackScreen.show()
	await get_tree().create_timer(1).timeout
	$IntroBlackScreen/AnimationPlayer.play("lift")
	await $IntroBlackScreen/AnimationPlayer.animation_finished
	await get_tree().create_timer(1).timeout
	$WhiteScreen.fadeOut()
	await $WhiteScreen.fade_finished
	$Dialog.showDialog([
			"normal@Take a breath. It must've been stuffy in there.",
			"I am [b]Sky Elmwood Dazzle[/b] from the [b]Ministry of State Security[/b].",
			"You have been found guilty of treason and sentenced to death.",
			"...",
			"Well of [b]course[/b] you didn't have a trial, we don't do that here at the Ministry.",
			"We're scheduling your execution right now. The shooting grounds are a little busy so you'd have to be patient.",
			"But here's the thing. The Ministry has offered you a chance to be set free.",
			"All you need to do is —"
		])
	await $Dialog.dialog_finished
	get_tree().change_scene_to_file("res://scenes/Tutorial/tutorial.tscn")
