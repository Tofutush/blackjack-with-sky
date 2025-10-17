extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

func _ready() -> void:
	pass

func _on_bet_bet_submitted(amount: int) -> void:
	play(amount)

func play(bet: int) -> void:
	# create decks
	mainDeck = GameManager.createDeck()
	playerHand = Deck.new([])
	dealerHand = Deck.new([])

	# deal initial cards
	playerHand.addCard(mainDeck.drawRandom())
	playerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	$PlayerCards.text = "player: " + playerHand.getCard(0).toText() + ", " + playerHand.getCard(1).toText() + ", value " + playerHand.getValueString()
	$DealerCards.text = "dealer: " + dealerHand.getCard(0).toText() + ", " + dealerHand.getCard(1).toText() + ", value " + dealerHand.getValueString()

	# check natural blackjack
	if isNaturalBlackjack(playerHand):
		print('natural blackjack! you win!')

	# check split
	if isSameRank(playerHand.getCard(0), playerHand.getCard(1)):
		print('splittable')

	# player draw loop

	# dealer draw loop

# check functions
func isNaturalBlackjack(deck: Deck) -> bool:
	var value = deck.getValue()
	return value['soft'] && value['value'].has(21)

func isSameRank(card1: Card, card2: Card) -> bool:
	return card1.rank == card2.rank

func isEndForDealer(dealerHand: Deck) -> bool:
	var total = dealerHand.getValue()
	if total['soft']:
		if total['value'][0] > 17:
			# same logic, here both values are larger than 17
			return true
		if total['value'][1] > 17:
			# this is if we hit a soft 17 but it can be smaller
			return GameManager.standOnSoft17
		return false
	return total['value'] > 17
