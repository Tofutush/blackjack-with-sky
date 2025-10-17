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
	var sum = 0
	var aces = 0
	var soft = false
	for card in deck:
		sum += card.getValue()
		if card.isSoft():
			soft = true
			aces = aces + 1
	if soft:
		return {
			'soft': true,
			'value': [sum, sum + aces * 10]
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
