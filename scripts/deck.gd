extends Resource
class_name Deck

var deck: Array

# we're using the same class for player, dealer, and the drawpile and well, we were supposed to make inherited classes, but most of the time each class only gets 1 instance so whats the point? so some of the methods here are exclusive to player / dealer / drawpile. just use them properly and youll be fine

func _init(deck1: Array) -> void:
	deck = deck1

func shuffle() -> Deck:
	deck.shuffle()
	return self

func drawRandom() -> Card:
	return deck.pop_back()

func getCard(index: int) -> Card:
	return deck[index]

func addCard(card: Card) -> Deck:
	deck.append(card)
	return self

func getValue() -> Dictionary:
	# get value, if soft returns an array sorted so the first element is always smaller
	var sum = 0
	var aces = 0
	var soft = false
	for card in deck:
		sum += card.getValue()
		if card.isSoft():
			soft = true
			aces = aces + 1
	if soft:
		var value = [sum]
		for ace in aces:
			var tempArray = []
			for each in value:
				if not value.has(each + 10):
					tempArray.append(each + 10)
			value.append_array(tempArray)
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
	var total = getValue()
	if total['soft']:
		return "either " + str(total['value'][0]) + " or " + str(total['value'][1])
	else:
		return str(total['value'])

func isNaturalBlackjack() -> bool:
	var total = getValue()
	# must be one ace (soft) and one 10
	return total['soft'] && total['value'][1] == 21

func isBusted() -> bool:
	var total = getValue()
	if total['soft']:
		# smallest value larger than 21, since total['value'] is sorted
		return total['value'][0] > 21
	return total['value'] > 21

func isEndForDealer() -> bool:
	var total = getValue()
	if total['soft']:
		if total['value'][0] >= 17:
			# same logic, here all values are larger than / equal to 17
			return true
		if total['value'].any(func(number): return number < 17) and total['value'].any(func(number): return number >= 17):
			# this is if we have over 17 ones and under 17 ones. we decide based on the setting
			return GameManager.standOnSoft17
		return false
	return total['value'] >= 17
