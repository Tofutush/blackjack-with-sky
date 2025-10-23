extends Resource
class_name Deck
## a deck, different from DeckDisplay. the core of this is the deck variable, an array of Cards
##
## we're using the same class for player, dealer, and the drawpile and well, we were supposed to make inherited classes, but most of the time each class only gets 1 instance so whats the point? so some of the methods here are exclusive to player / dealer / drawpile. just use them properly and youll be fine

var deck: Array[Card] ## array of Cards in deck
var display: DeckDisplay ## an optional DeckDisplay to link, for dealer and player

## inits with an array of Cards
func _init(deck1: Array[Card]) -> void:
	deck = deck1

# general

## get the card at index
func getCard(index: int) -> Card:
	return deck[index]

## get how many cards there are
func getCardCount() -> int:
	return deck.size()

# drawpile

## shuffles the deck, returns self for chaining
func shuffle() -> Deck:
	deck.shuffle()
	return self

## returns the last card from the deck, removing it at the same time
func drawRandom() -> Card:
	return deck.pop_back()

## returns a card of a specific rank, removing it from deck
func drawRigged(rank: String) -> Card:
	return deck.pop_at(deck.find_custom(func(card: Card): return card.rank == rank))

# player & dealer

## set a DeckDisplay to update it as the cards in this deck change
func linkDisplay(display1: DeckDisplay):
	# auto-update the DeckDisplay
	display = display1
	display.deck = self
	display.clear()
	for card in deck:
		display.addCard(card)

## add a card to the deck, optional whether the card should be face-down
func addCard(card: Card, back = false) -> Deck:
	deck.append(card)
	if display: display.addCard(card, back)
	return self

## get total value of deck. returns dictionary.
##
## dictionary property 'soft' boolean, false if value fixed and 'value' would be int
##
## true if deck involves aces, 'value' would be array of all possible values (including >21 ones) sorted small to big
func getValue() -> Dictionary:
	var sum = 0
	var aces = 0
	var soft = false
	for card: Card in deck:
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

## get the highest value that's not bust
func getHighestValidValue() -> int:
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

## 1 if highest valid value of this deck is larger, -1 if other is larger, 0 if tie
func compareValue(otherDeck: Deck) -> int:
	var value1 = getHighestValidValue()
	var value2 = otherDeck.getHighestValidValue()
	if value1 == value2: return 0
	if value1 > value2: return 1
	return -1

# toString functions

## just a list of all values, i didnt bother removing the comma at the end lmao
func toValueString() -> String:
	var total = getValue()
	if total['soft']:
		var string = ''
		for val in total['value']:
			string += str(val) + ', '
		return string
	else:
		return str(total['value'])

## a list of "rank of suit"s, i didnt bother removing the comma at the end lmao
func toString() -> String:
	var string = ''
	for card in deck:
		string += card.toString() + ', '
	return string

# checks

## checks if natural bj
func isNaturalBlackjack() -> bool:
	var total = getValue()
	# must be one ace (soft) and one 10
	return deck.size() == 2 && total['soft'] && total['value'][1] == 21

## check if busted
func isBusted() -> bool:
	var total = getValue()
	if total['soft']:
		# smallest value larger than 21, since total['value'] is sorted
		return total['value'][0] > 21
	return total['value'] > 21

## check if dealer should stop
func isEndForDealer() -> bool:
	var total = getValue()
	if total['soft']:
		if total['value'].has(21): return true
		if total['value'][0] >= 17: return true
		if total['value'].any(func(number): return number < 17) and total['value'].any(func(number): return number >= 17):
			# this is if we have over 17 ones and under 17 ones. we decide based on the setting
			return GameManager.standOnSoft17
		return false
	return total['value'] >= 17

## check if hand is splittable. does NOT take game settings into consideration
func isSplittable() -> bool:
	if !deck.size() == 2: return false
	return deck[0].compareRank(deck[1])

## player - split. errors if deck size not 2, removes one card, returns new Deck with the other card
func split() -> Deck:
	if !deck.size() == 2: push_error('you can only split on 2-card decks')
	if display:
		display.removeCard(1)
	return Deck.new([deck.pop_back()])
