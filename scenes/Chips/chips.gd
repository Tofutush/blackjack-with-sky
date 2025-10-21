extends Control

const WIDTH = 100
const HEIGHT = 55
const REGIONS = {
	'red': Vector2(0, 0),
	'white': Vector2(0, WIDTH),
	'blue': Vector2(0, WIDTH * 2),
	'green': Vector2(0, WIDTH * 3),
	'black': Vector2(0, WIDTH * 4)
}

var white # $1
var red # $5
var blue # $10
var green # $25
var black # $100

var img = preload("res://assets/chip red.png")

func _ready() -> void:
	hide()
	setChips(17)

func setChips(number: int) -> void:
	var dict = calcNumber(number)
	black = dict['black']
	green = dict['green']
	blue = dict['blue']
	red = dict['red']
	white = dict['white']
	showChips()

func doubleChips() -> void:
	black *= 2
	green *= 2
	blue *= 2
	red *= 2
	white *= 2
	showChips()

func showChips() -> void:
	#var string = ''
	#if black != 0: string += str(black) + ' black, '
	#if green != 0: string += str(green) + ' green, '
	#if blue != 0: string += str(blue) + ' blue, '
	#if red != 0: string += str(red) + ' red, '
	#if white != 0: string += str(white) + ' white, '
	#$Label.text = string
	if black != 0:
		var node = Control.new()
		node.size = Vector2(50, 50)
		node.position = Vector2(0, 0)
		for i in black:
			var sprite = Sprite2D.new()
			sprite.texture = img
			sprite.modulate = Color()
			sprite.centered = false
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position = Vector2(0, i * 11)
			node.add_child(sprite)
		$HBoxContainer.add_child(node)
	if green != 0:
		var node = Control.new()
		node.size = Vector2(50, 50)
		for i in green:
			var sprite = Sprite2D.new()
			sprite.texture = img
			sprite.modulate = Color(0, 1, 0)
			sprite.centered = false
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position = Vector2(0, i * 11)
			node.add_child(sprite)
		$HBoxContainer.add_child(node)
	if blue != 0:
		var node = Control.new()
		node.size = Vector2(50, 50)
		for i in blue:
			var sprite = Sprite2D.new()
			sprite.texture = img
			sprite.modulate = Color(0, 0, 1)
			sprite.centered = false
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position = Vector2(0, i * 11)
			node.add_child(sprite)
		$HBoxContainer.add_child(node)
	if red != 0:
		var node = Control.new()
		node.size = Vector2(50, 50)
		for i in red:
			var sprite = Sprite2D.new()
			sprite.texture = img
			sprite.modulate = Color(1, 0, 0)
			sprite.centered = false
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position = Vector2(0, i * 11)
			node.add_child(sprite)
		$HBoxContainer.add_child(node)
	if white != 0:
		var node = Control.new()
		node.size = Vector2(50, 50)
		for i in white:
			var sprite = Sprite2D.new()
			sprite.texture = img
			sprite.modulate = Color(1, 1, 1)
			sprite.centered = false
			sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			sprite.position = Vector2(0, i * 11)
			node.add_child(sprite)
		$HBoxContainer.add_child(node)
	show()

func clearChips() -> void:
	black = 0
	green = 0
	blue = 0
	red = 0
	white = 0
	$Label.text = ''
	hide()

func calcNumber(number: int) -> Dictionary:
	var dict = {
		'black': 0,
		'green': 0,
		'blue': 0,
		'red': 0,
		'white': 0
	}
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
