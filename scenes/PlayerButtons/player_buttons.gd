extends HBoxContainer

signal hit
signal stand
signal double_down
signal surrender

@onready var hit_button: Button = $HBoxContainer/HitButton
@onready var stand_button: Button = $HBoxContainer/StandButton
@onready var double_down_button: Button = $DoubleDownButton
@onready var surrender_button: Button = $HBoxContainer/SurrenderButton

func _ready() -> void:
	disableButtons()

func disableButtons() -> void:
	hit_button.disabled = true
	stand_button.disabled = true
	double_down_button.disabled = true
	surrender_button.disabled = true

func hideDoubleDownButton() -> void:
	double_down_button.hide()

func enableButtons() -> void:
	hit_button.disabled = false
	stand_button.disabled = false
	double_down_button.disabled = false
	surrender_button.disabled = false
	double_down_button.show()

func _on_hit_button_pressed() -> void:
	hit.emit()

func _on_stand_button_pressed() -> void:
	stand.emit()

func _on_double_down_button_pressed() -> void:
	double_down.emit()

func _on_surrender_button_pressed() -> void:
	surrender.emit()
