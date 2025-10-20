extends Control

var purpose

signal bet_submitted(amount: int, purpose: String)

func startBetting(maximum: int, purpose1: String) -> void:
	purpose = purpose1
	$Label.text = "$1"
	$Slider.max_value = maximum
	$Slider.value = 1
	show()

func _on_slider_value_changed(value: float) -> void:
	$Label.text = "$" + str(int(value))

func _on_button_pressed() -> void:
	bet_submitted.emit(int($Slider.value), purpose)
	hide()
