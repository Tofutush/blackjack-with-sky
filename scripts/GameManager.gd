extends Node

var money := 100
var standOnSoft17 := false
var deckNumber = 1
var strictSplitting = true

signal money_changed(amount: int)

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

func changeMoney(amount: int) -> void:
	money += amount
	# we flooring it here though i think i floor it when calling the function anyways
	money = floor(money)
	if money < 0: push_error('money somehow < 0, this is not possible, go check what happened')
	money_changed.emit(money)
