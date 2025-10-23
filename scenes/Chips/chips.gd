extends Control
class_name Chips
## UI display of chips

const WIDTH = 100 ## width of chips in the img
const HEIGHT = 55 ## height of chips in the img
## regions for chip colors
const REGIONS = {
	'red': Vector2(0, 0),
	'white': Vector2(0, HEIGHT),
	'blue': Vector2(0, HEIGHT * 2),
	'green': Vector2(0, HEIGHT * 3),
	'black': Vector2(0, HEIGHT * 4)
}

## dict for chip values
var dict = {
	'white': 0, # $1
	'red': 0, # $5
	'blue': 0, # $10
	'green': 0, # $25
	'black': 0 # $100
}

var img = preload("res://assets/chip red.png")

func _ready() -> void:
	clearDisplay()

## set chip number, and show
func setChips(number: int) -> void:
	dict = calcNumber(number)
	showChips()

## double value of current chips, and show
func doubleChips() -> void:
	for key in dict:
		dict[key] *= 2
	showChips()

## triple value of current chips, and show
func tripleChips() -> void:
	for key in dict:
		dict[key] *= 3
	showChips()

# TODO: currently adding more chips (double down only) will push the bottom down instead of highering — fix that
## show chips display
func showChips() -> void:
	clearDisplay()
	for key in dict:
		if dict[key] != 0:
			var node = VBoxContainer.new()
			node.alignment = BoxContainer.ALIGNMENT_END
			node.add_theme_constant_override('separation', -35)
			for i in dict[key]:
				var sprite = TextureRect.new()
				sprite.texture = AtlasTexture.new()
				sprite.texture.atlas = img
				sprite.texture.region = Rect2(REGIONS[key], Vector2(WIDTH, HEIGHT))
				sprite.z_index = dict[key] - i
				node.add_child(sprite)
			$HBoxContainer.add_child(node)
	show()

## sets all colors to 0
func clearChips() -> void:
	for key in dict:
		dict[key] = 0
	clearDisplay()

## clears display without setting chip numbers to 0
func clearDisplay() -> void:
	for child in $HBoxContainer.get_children():
		child.queue_free()

func calcNumber(number: int) -> Dictionary:
	dict['black'] = int(floor(number / 100.0))
	number = number % 100
	dict['green'] = int(floor(number / 25.0))
	number = number % 25
	dict['blue'] = int(floor(number / 10.0))
	number = number % 10
	dict['red'] = int(floor(number / 5.0))
	number = number % 5
	dict['white'] = number
	return dict
