extends HBoxContainer

signal hit
signal stand
signal surrender
signal insurance
signal split
signal double_down

var dict: Dictionary[String, Button]

func _ready() -> void:
	dict = {
		'hit': $Right/HitButton,
		'stand': $Right/StandButton,
		'surrender': $Right/SurrenderButton,
		'insurance': $Left/InsuranceButton,
		'split': $Left/SplitButton,
		'double down': $Left/DoubleDownButton
	}
	disableButtons()

func disableButtons() -> void:
	# disable every button
	for key in dict:
		dict[key].disabled = true

func disableButton(key: String) -> void:
	if !dict[key]: push_error('button doesnt exist: ' + key)
	dict[key].disabled = true

func enableButtons() -> void:
	# enable all buttons
	for key in dict:
		dict[key].disabled = false

func enableButton(key: String) -> void:
	if !dict[key]: push_error('button doesnt exist: ' + key)
	dict[key].disabled = false

func setButtonTooltip(button: String, text: String) -> void:
	if !dict[button]: push_error('button doesnt exist: ' + button)
	dict[button].tooltip_text = text

func _on_hit_button_pressed() -> void:
	hit.emit()

func _on_stand_button_pressed() -> void:
	stand.emit()

func _on_surrender_button_pressed() -> void:
	surrender.emit()

func _on_insurance_button_pressed() -> void:
	insurance.emit()

func _on_split_button_pressed() -> void:
	split.emit()

func _on_double_down_button_pressed() -> void:
	double_down.emit()
