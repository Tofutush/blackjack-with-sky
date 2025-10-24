extends ColorRect
class_name BlackScreen
## FOOLED YA not actually black. you can set color

signal fade_finished ## emit when fade finished, whether in or out

func _ready() -> void:
	hide()

## change color of screen
func setColor(color1: Color) -> void:
	color = color1

## make screen show in 1s
func fadeIn() -> void:
	show()
	$AnimationPlayer.play("fade in")
	await $AnimationPlayer.animation_finished
	fade_finished.emit()

## make screen hide in 1s
func fadeOut() -> void:
	show()
	$AnimationPlayer.play("fade out")
	await $AnimationPlayer.animation_finished
	fade_finished.emit()
	hide()
