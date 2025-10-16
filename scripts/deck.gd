extends Resource
class_name Deck

var deck: Array[Card]

func _init(deck: Array[Card]) -> void:
	self.deck = deck

func drawRandom() -> Card:
	var index = randi_range(0, deck.size() - 1)
	return deck.pop_at(index)
