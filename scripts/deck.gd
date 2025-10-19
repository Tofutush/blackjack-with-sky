extends Resource
class_name Deck

var deck: Array
var display: DeckDisplay

# we're using the same class for player, dealer, and the drawpile and well, we were supposed to make inherited classes, but most of the time each class only gets 1 instance so whats the point? so some of the methods here are exclusive to player / dealer / drawpile. just use them properly and youll be fine

func _init(deck1: Array) -> void:
	deck = deck1

# general
func getCard(index: int) -> Card:
	return deck[index]

func getCardCount() -> int:
	return deck.size()

# drawpile
func shuffle() -> Deck:
	deck.shuffle()
	return self

func drawRandom() -> Card:
	return deck.pop_back()

# player & dealer
func linkDisplay(display1: DeckDisplay):
	# auto-update the DeckDisplay
	display = display1
	display.deck = self

func addCard(card: Card, back = false) -> Deck:
	deck.append(card)
	if display:
		display.addCard(card, back)
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

func getHighestValidValue() -> int:
	# get the highest value that's not bust
	var value = getValue()
	if value['soft']:
		var idx = value['value'].size() - 1
		for index in value['value'].size():
			if value['value'][index] > 21:
				idx = index - 1
				break
		if idx == -1:
			push_error('array of values all > 21, this func shouldnt have been called')
			return -1
		return value['value'][idx]
	elif value['value'] > 21:
		push_error('single value > 21, this func shouldnt have been called')
		return -1
	return value['value']

func compareValue(otherDeck: Deck) -> int:
	# 1 if this is larger, -1 if other is larger, 0 if tie
	var value1 = getHighestValidValue()
	var value2 = otherDeck.getHighestValidValue()
	if value1 == value2: return 0
	if value1 > value2: return 1
	return -1

# toString functions
func toValueString() -> String:
	var total = getValue()
	if total['soft']:
		var string = ''
		for val in total['value']:
			string += str(val) + ', '
		return string
	else:
		return str(total['value'])

func toString() -> String:
	var string = ''
	for card in deck:
		string += card.toString() + ', '
	return string

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
