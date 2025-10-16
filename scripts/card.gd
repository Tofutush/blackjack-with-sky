extends Resource
class_name Card

var suit: String
var rank: String

func _init(suit: String, rank: String) -> void:
	self.suit = suit
	self.rank = rank

func getValue() -> Dictionary:
	match rank:
		"A":
			return {
				'soft': true,
				'value': [1, 11]
			}
		"J", "Q", "K":
			return {
				'soft': false,
				'value': 10
			}
		_:
			return {
				'soft': false,
				'value': int(rank)
			}
