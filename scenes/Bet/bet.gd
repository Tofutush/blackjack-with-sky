extends Control

signal bet_submitted(amount: int)

func _ready() -> void:
	$Label.text = "$1"
	$Slider.max_value = GameManager.money

func _on_slider_value_changed(value: float) -> void:
	$Label.text = "$" + str(int(value))

func _on_button_pressed() -> void:
	bet_submitted.emit(int($Slider.value))
