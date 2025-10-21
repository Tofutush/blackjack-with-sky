extends Control
class_name DeckDisplay

func _ready() -> void:
	clear()

func clear() -> void:
	for child in get_children():
		child.queue_free()

func addCard(card: Card, back = false) -> void:
	var sprite = preload("res://scenes/CardDisplay/card_display.tscn").instantiate()
	sprite.card = card
	# offsets it by 38 * the number of children it has already so it shows the side of the prev card
	sprite.position = Vector2(38 * get_child_count(), 0)
	if back: sprite.showBack()
	else: sprite.showFront()
	add_child(sprite)

func removeCard(idx: int) -> void:
	get_child(idx).queue_free()
