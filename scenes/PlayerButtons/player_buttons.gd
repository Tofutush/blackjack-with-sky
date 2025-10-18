extends VBoxContainer

signal hit
signal stand
signal double_down
signal surrender

func _ready() -> void:
	disableButtons()

func disableButtons() -> void:
	$HitButton.disabled = true
	$StandButton.disabled = true
	$DoubleDownButton.disabled = true
	$SurrenderButton.disabled = true

func enableButtons() -> void:
	$HitButton.disabled = false
	$StandButton.disabled = false
	$DoubleDownButton.disabled = false
	$SurrenderButton.disabled = false

func _on_hit_button_pressed() -> void:
	hit.emit()

func _on_stand_button_pressed() -> void:
	stand.emit()

func _on_double_down_button_pressed() -> void:
	double_down.emit()

func _on_surrender_button_pressed() -> void:
	surrender.emit()
