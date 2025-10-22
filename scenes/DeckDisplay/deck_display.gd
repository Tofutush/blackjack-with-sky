extends Control
class_name DeckDisplay

var deck: Deck

func _ready() -> void:
	clear()

func clear() -> void:
	for child in $HBoxContainer.get_children():
		child.queue_free()

func addCard(card: Card, back = false) -> void:
	var sprite = preload("res://scenes/CardDisplay/card_display.tscn").instantiate()
	sprite.card = card
	if back: sprite.showBack()
	else: sprite.showFront()
	$HBoxContainer.add_child(sprite)

func removeCard(idx: int) -> void:
	$HBoxContainer.get_child(idx).queue_free()

func turnLastBackCard() -> void:
	if deck and $HBoxContainer.get_child_count() != 0:
		var child: CardDisplay = $HBoxContainer.get_child($HBoxContainer.get_child_count() - 1)
		child.showFront()
