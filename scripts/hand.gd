extends Node
class_name Hand

# A class that manages a Deck, a DeckDisplay, and a Chips

var deck: Deck
var deckDisplay: DeckDisplay

func _init(deck1: Deck, deckD: DeckDisplay) -> void:
	deck = deck1
	deckDisplay = deckD

func addCard(card: Card) -> void:
	deck.addCard(card)
	deckDisplay.addCard(card)

func turnLastBackCard() -> void:
	if deckDisplay.get_child_count() != 0:
		var child = deckDisplay.get_child(deckDisplay.get_child_count() - 1)
		child.showFront()
