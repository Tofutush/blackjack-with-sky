extends Control
class_name DeckDisplay

@export var cardScale: float
var deck: Deck

func _ready() -> void:
	clear()

func clear() -> void:
	for child in get_children():
		child.queue_free()

func addCard(card: Card, back = false) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://assets/cards.png")
	# determine which region to pick
	if back:
		sprite.region_rect = Rect2(Vector2(0, 294 * 4), Vector2(209, 294))
	else:
		sprite.region_rect = getRegion(card)
	sprite.region_enabled = true
	sprite.centered = false
	# offsets it by 38 * the number of children it has already so it shows the side of the prev card. also multiplies it by scale
	sprite.position = Vector2(38 * cardScale * get_child_count(), 0)
	sprite.scale = Vector2(cardScale, cardScale)
	add_child(sprite)

func turnLastBackCard() -> void:
	if deck and get_child_count() != 0:
		var lastCard = deck.getCard(deck.getCardCount() - 1)
		var child = get_child(get_child_count() - 1)
		child.region_rect = getRegion(lastCard)

func getRegion(card: Card) -> Rect2:
	var x: int
	var y: int
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
	return Rect2(Vector2(x, y), Vector2(209, 294))
