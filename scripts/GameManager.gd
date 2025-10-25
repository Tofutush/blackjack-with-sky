extends Node

var money := 100 ## how much money you have in total
var standOnSoft17 := false ## whether dealer stands when they reach soft 17
var deckNumber := 1 ## how many decks to play with, 1 - 8
var textAnimation := true ## whether to animate letters appearing one by one

## strict splitting:
## - only split exact same rank
## - 4 hands max
## - splitting aces can only get one more card
## - no doubling down after splitting
## no strict splitting
## - split any 10-card
## - unlimited hands
## - play aces like normal
## - double down after splitting
var strictSplitting = true

## emitted whenever money is changed, mostly for the MoneyMeter (dont let win/lose check do it because it emits in the middle of games)
signal money_changed(amount: int)

## create a deck according to deckNumber
func createDeck() -> Deck:
	const suits = ['Spades', 'Hearts', 'Clubs', 'Diamonds']
	const ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
	var cards: Array[Card] = []
	for i in deckNumber:
		for rank in ranks:
			for suit in suits:
				var card = Card.new(suit, rank)
				cards.append(card)
	return Deck.new(cards).shuffle()

## called whenever other ppl wanna change money. floors it. throws error if end money is negative. emits signal
func changeMoney(amount: int) -> void:
	money += amount
	# we flooring it here though i think i floor it when calling the function anyways
	money = floor(money)
	if money < 0: push_error('money somehow < 0, this is not possible, go check what happened')
	money_changed.emit(money)
