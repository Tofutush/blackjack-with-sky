extends Control

# White = $1
# Red = $5
# Blue = $10
# Green = $25
# Black = $100

func _ready() -> void:
	hide()

func showChips(number: int) -> void:
	var string = ''

	var black = int(floor(number / 100.0))
	number = number % 100
	if black != 0: string += str(black) + ' black, '
	if number == 0: return

	var green = int(floor(number / 25.0))
	number = number % 25
	if green != 0: string += str(green) + ' green, '
	if number == 0: return

	var blue = int(floor(number / 10.0))
	number = number % 10
	if blue != 0: string += str(blue) + ' blue, '
	if number == 0: return

	var red = int(floor(number / 5.0))
	number = number % 5
	if red != 0: string += str(red) + ' red, '
	if number == 0: return

	var white = number
	if white != 0: string += str(white) + ' white, '

	print(string)
	$Label.text = string
	show()
