extends TextureRect
class_name CardDisplay
## a texture atlas. UI. different from Card.

const WIDTH = 209 ## width of cards in that img. i hope i dont change this
const HEIGHT = 294 ## height of cards in the img
const BACK_REGION = Rect2(Vector2(0, HEIGHT * 4), Vector2(WIDTH, HEIGHT)) ## top-left corner of the back card

## the card this Display will display
var card: Card

func _ready() -> void:
	texture = texture.duplicate()
	$AnimationPlayer.play("slidein")

## show the front of this card
func showFront() -> void:
	if texture.region != getRegion(): texture.region = getRegion()

## show the back of this card
func showBack() -> void:
	if texture.region != BACK_REGION: texture.region = BACK_REGION

## plays animation as card is turned
func turnBack() -> void:
	$AnimationPlayer.play("squash")
	await $AnimationPlayer.animation_finished
	showFront()
	$AnimationPlayer.play("expand")
	await $AnimationPlayer.animation_finished

## get the top-left corner of the region we need to crop out
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
