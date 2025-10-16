extends Resource
class_name Deck

var deck: Array

func _init(deck1: Array) -> void:
	deck = deck1

func drawRandom() -> Card:
	var index = randi_range(0, deck.size() - 1)
	return deck.pop_at(index)
