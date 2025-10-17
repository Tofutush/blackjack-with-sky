extends Resource
class_name Card

var suit: String
var rank: String

func _init(suit1: String, rank1: String) -> void:
	suit = suit1
	rank = rank1
	print(getValue())

func getValue() -> int:
	match rank:
		"A": return 1
		"J", "Q", "K": return 10
		_: return int(rank)

func isSoft() -> bool:
	return rank == "A"

func toText() -> String:
	return rank + " of " + suit
