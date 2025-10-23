extends Resource
class_name Card
## a single card. different from CardDisplay

var suit: String
var rank: String

## inits the card with a suit and a rank, both strings
func _init(suit1: String, rank1: String) -> void:
	suit = suit1
	rank = rank1

## gets value of card. returns one value only, 1 for ace
func getValue() -> int:
	match rank:
		"A": return 1
		"J", "Q", "K": return 10
		_: return int(rank)

## checks if its soft, ie is rank A
func isSoft() -> bool:
	return rank == "A"

## "rank of suit"
func toString() -> String:
	return rank + " of " + suit

## bad name. whether rank is equal, t/f
func compareRank(card: Card) -> bool:
	return rank == card.rank
