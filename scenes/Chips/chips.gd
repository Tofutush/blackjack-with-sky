extends Control

var white # $1
var red # $5
var blue # $10
var green # $25
var black # $100

func _ready() -> void:
	hide()

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
	var string = ''
	if black != 0: string += str(black) + ' black, '
	if green != 0: string += str(green) + ' green, '
	if blue != 0: string += str(blue) + ' blue, '
	if red != 0: string += str(red) + ' red, '
	if white != 0: string += str(white) + ' white, '
	$Label.text = string
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
