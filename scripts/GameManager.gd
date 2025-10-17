extends Node

var money := 100
var standOnSoft17 := false

func createDeck() -> Deck:
	const suits = ['Spades', 'Hearts', 'Clubs', 'Diamonds']
	const ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
	var cards = []
	for rank in ranks:
		for suit in suits:
			var card = Card.new(suit, rank)
			cards.append(card)
	return Deck.new(cards)
