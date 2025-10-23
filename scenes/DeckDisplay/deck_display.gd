extends Control
class_name DeckDisplay
## UI, different from Deck, can be linked in the Deck class

func _ready() -> void:
	clear()

## kill all children
func clear() -> void:
	for child in $HBoxContainer.get_children():
		child.queue_free()

## add a card
func addCard(card: Card, back = false) -> void:
	var sprite = preload("res://scenes/CardDisplay/card_display.tscn").instantiate()
	sprite.card = card
	if back: sprite.showBack()
	else: sprite.showFront()
	$HBoxContainer.add_child(sprite)

## remove a card at idx
func removeCard(idx: int) -> void:
	$HBoxContainer.get_child(idx).queue_free()

## make the last card show, mainly used by dealer to show down card
func turnLastBackCard() -> void:
	if $HBoxContainer.get_child_count() != 0:
		var child: CardDisplay = $HBoxContainer.get_child($HBoxContainer.get_child_count() - 1)
		child.showFront()
