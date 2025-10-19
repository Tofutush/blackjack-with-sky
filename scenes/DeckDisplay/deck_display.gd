extends Control

func _ready() -> void:
	for child in get_children():
		child.queue_free()

func addCard(card: Card) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/cards.png")
	var x
	var y
	match card.suit:
		'Diamonds':
			y = 0
		'Hearts':
			y = 294
		'Spades':
			y = 294 * 2
		'Clubs':
			y = 294 * 3
		_:
			push_error('card suit doesnt exist: ' + card.suit)
	match card.rank:
		'A':
			x = 0
		'J':
			x = 209 * 10
		'Q':
			x = 209 * 11
		'K':
			x = 209 * 12
		_:
			x = 209 * (int(card.rank) - 1)
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2(x, y), Vector2(209, 294))
	sprite.centered = false
	sprite.position = Vector2(48 * (get_child_count() - 1), 0)
	add_child(sprite)
