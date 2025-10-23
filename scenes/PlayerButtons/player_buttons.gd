extends HBoxContainer
## script for all em actions player can take. hit, stand, surrender, insurance, split, double down. mainly here to emit middleman signals

signal hit ## player action hit
signal stand ## player action stand
signal surrender ## player action surrender
signal insurance ## player action insurance
signal split ## player action split
signal double_down ## player action double_down

## dict for quick n dirty access to buttons
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

## disable every button
func disableButtons() -> void:
	for key in dict:
		dict[key].disabled = true

## disable specific button
func disableButton(key: String) -> void:
	if !dict[key]: push_error('button doesnt exist: ' + key)
	dict[key].disabled = true

## enable every button
func enableButtons() -> void:
	for key in dict:
		dict[key].disabled = false

## enable specific button
func enableButton(key: String) -> void:
	if !dict[key]: push_error('button doesnt exist: ' + key)
	dict[key].disabled = false

## set a tooltip for button
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
