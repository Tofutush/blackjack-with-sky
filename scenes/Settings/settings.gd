extends VBoxContainer

func _ready() -> void:
	$Soft17/CheckBox.button_pressed = GameManager.standOnSoft17
	$StrictSplitting/CheckBox.button_pressed = GameManager.strictSplitting
	$Decks/DeckSlider.value = GameManager.deckNumber
	$Volume/VolumeSlider.value = AudioServer.get_bus_volume_db(0)

func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	GameManager.saveSettings()

func _on_deck_slider_value_changed(value: float) -> void:
	var valueInt := int(value)
	GameManager.deckNumber = valueInt
	$Decks/DeckCountLabel.text = str(valueInt)
	GameManager.saveSettings()

func _on_soft_17_toggled(toggled_on: bool) -> void:
	GameManager.standOnSoft17 = toggled_on
	GameManager.saveSettings()

func _on_strict_splitting_toggled(toggled_on: bool) -> void:
	GameManager.strictSplitting = toggled_on
	GameManager.saveSettings()
