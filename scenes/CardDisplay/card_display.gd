extends TextureRect
class_name CardDisplay

const WIDTH = 209
const HEIGHT = 294
const BACK_REGION = Rect2(Vector2(0, HEIGHT * 4), Vector2(WIDTH, HEIGHT))

var card: Card

func _ready() -> void:
	texture = texture.duplicate()

func showFront() -> void:
	texture.region = getRegion()

func showBack() -> void:
	texture.region = BACK_REGION

func getRegion() -> Rect2:
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
	return Rect2(Vector2(x, y), Vector2(WIDTH, HEIGHT))
