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
	# subtract bet
	GameManager.changeMoney(-bet)

	# create decks
	mainDeck = GameManager.createDeck()
	playerHand = Deck.new([])
	dealerHand = Deck.new([])

	# deal initial cards
	playerHand.addCard(mainDeck.drawRandom())
	playerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	$PlayerDeckDisplay.addCard(playerHand.getCard(0))
	$PlayerDeckDisplay.addCard(playerHand.getCard(1))
	$DealerDeckDisplay.addCard(dealerHand.getCard(0))
	$DealerDeckDisplay.addCard(dealerHand.getCard(1))

	# check natural blackjack
	if playerHand.isNaturalBlackjack():
		print('natural blackjack! you win!')
		GameManager.changeMoney(floor(bet * 1.5))

	# check split
	if playerHand.getCard(0).compareRank(playerHand.getCard(1)):
		print('splittable')

	# player draw
	$PlayerButtons.enableButtons()

	# dealer draw loop

func _on_player_hit() -> void:
	pass # Replace with function body.

func _on_player_double_down() -> void:
	pass # Replace with function body.

func _on_player_stand() -> void:
	pass # Replace with function body.

func _on_player_surrender() -> void:
	pass # Replace with function body.
