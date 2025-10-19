extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

func _ready() -> void:
	$Bet.startBetting()
	$PlayerButtons.disableButtons()

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
	$PlayerCards.text = "Player: " + playerHand.toString() + "value " + playerHand.toValueString()
	$DealerCards.text = "Dealer: " + dealerHand.toString() + "value " + dealerHand.toValueString()

	# check natural blackjack
	if playerHand.isNaturalBlackjack():
		print('natural blackjack! you win!')
		GameManager.changeMoney(floor(bet * 1.5))

	# check split
	if playerHand.getCard(0).compareRank(playerHand.getCard(1)):
		print('splittable')

	# player draw loop
	$PlayerButtons.enableButtons()

	# dealer draw loop

func _on_player_buttons_hit() -> void:
	pass # idk what to do now
