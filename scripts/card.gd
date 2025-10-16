extends Resource
class_name Card

var suit: String
var rank: String

func _init(suit1: String, rank1: String) -> void:
	suit = suit1
	rank = rank1
	print(getValue())

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

func toText() -> String:
	return rank + " of " + suit
