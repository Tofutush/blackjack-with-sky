extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

func _ready() -> void:
	$Bet.startBetting()

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
	if playerHand.isNaturalBlackjack():
		print('natural blackjack! you win!')
		GameManager.money += floor(bet * 1.5)

	# check split
	if playerHand.getCard(0).compareRank(playerHand.getCard(1)):
		print('splittable')

	# player draw loop

	# dealer draw loop
