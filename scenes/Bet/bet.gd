extends Control

func _ready() -> void:
	$Label.text = "$1"
	$Slider.max_value = GameManager.money

func _on_slider_value_changed(value: float) -> void:
	$Label.text = "$" + str(int(value))
