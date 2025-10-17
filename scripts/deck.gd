extends Resource
class_name Deck

var deck: Array

func _init(deck1: Array) -> void:
	deck = deck1

func drawRandom() -> Card:
	var index = randi_range(0, deck.size() - 1)
	return deck.pop_at(index)

func getCard(index: int) -> Card:
	return deck[index]

func addCard(card: Card) -> void:
	deck.append(card)

func getValue() -> Dictionary:
	# get value, if soft returns an array sorted so the first element is always smaller
	# TODO: rewrite this to take all aces into account. currently it's either all 1's or all 10's
	var sum = 0
	var aces = 0
	var soft = false
	for card in deck:
		sum += card.getValue()
		if card.isSoft():
			soft = true
			aces = aces + 1
	if soft:
		var value = [sum, sum + aces * 10]
		value.sort()
		return {
			'soft': true,
			'value': value
		}
	else:
		return {
			'soft': false,
			'value': sum
		}

func getValueString() -> String:
	var value = getValue()
	if value['soft']:
		return "either " + str(value['value'][0]) + " or " + str(value['value'][1])
	else:
		return str(value['value'])

func isBusted() -> bool:
	var total = getValue()
	if total['soft']:
		# since total['value'] is sorted, the first element being larger than 21 guarantees a larger second element
		return total['value'][0] > 21
	return total['value'] > 21
