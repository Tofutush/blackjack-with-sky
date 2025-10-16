extends Node

func createDeck() -> Array:
	var suits = ['Spades', 'Hearts', 'Clubs', 'Diamonds']
	var ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
	var cards = []
	for rank in ranks:
		for suit in suits:
			var card = Card.new(suit, rank)
			print(card.getValue())
	return cards
