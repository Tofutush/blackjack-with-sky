extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

var bet: int

func _ready() -> void:
	newGame()

func newGame() -> void:
	$ContinueButton.hide()
	$Bet.startBetting()
	$PlayerButtons.disableButtons()

func _on_continue_button_pressed() -> void:
	newGame()

func _on_bet_bet_submitted(amount: int) -> void:
	bet = amount
	play()

func play() -> void:
	# subtract bet
	GameManager.changeMoney(-bet)

	# create decks
	mainDeck = GameManager.createDeck()
	playerHand = Deck.new([])
	playerHand.linkDisplay($PlayerDeckDisplay)
	dealerHand = Deck.new([])
	dealerHand.linkDisplay($DealerDeckDisplay)

	# deal initial cards
	playerHand.addCard(mainDeck.drawRandom())
	playerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom(), true)

	# check natural blackjack
	if playerHand.isNaturalBlackjack():
		print('natural blackjack! you win!')
		GameManager.changeMoney(floor(bet * 1.5))

	# check split
	if playerHand.getCard(0).compareRank(playerHand.getCard(1)):
		print('splittable')

	# player draw
	$PlayerButtons.enableButtons()

# 4 player options. these signals are middleman signals from $PlayerButtons
func _on_player_hit() -> void:
	playerHand.addCard(mainDeck.drawRandom())
	if playerHand.isBusted():
		print('you bust! you lose!')
		$PlayerButtons.disableButtons()
		$ContinueButton.show()
		return
	dealerDrawLoop()

func _on_player_double_down() -> void:
	# double down: bet double, hit once more, and stand
	# can only be done on round 1 just like insurance, so consider moving it out of the PlayerButtons list?
	if GameManager.money < bet:
		# the button should be disabled if you cant double down
		push_error('not enough money to double down')
	GameManager.changeMoney(-bet)
	bet *= 2
	playerHand.addCard(mainDeck.drawRandom())
	$PlayerButtons.disableButtons()
	# see if you can extract this into its own function so you can reuse it
	if playerHand.isBusted():
		print('you bust! you lose!')
		$ContinueButton.show()
		return
	dealerDrawLoop()

func _on_player_stand() -> void:
	$PlayerButtons.disableButtons()
	# dealer draw
	dealerDrawLoop()

func _on_player_surrender() -> void:
	# 2.0 to get rid of that warning while avoiding that stupid line of code
	GameManager.changeMoney(int(floor(bet / 2.0)))
	$PlayerButtons.disableButtons()
	$ContinueButton.show()
	return

func dealerDrawLoop() -> void:
	$DealerDeckDisplay.turnLastBackCard()
	# TODO: check insurance win
	while not dealerHand.isEndForDealer():
		dealerHand.addCard(mainDeck.drawRandom())
	if dealerHand.isBusted():
		GameManager.changeMoney(bet * 2)
		print('dealer over, you win')
	else:
		var result = playerHand.compareValue(dealerHand)
		match result:
			0:
				GameManager.changeMoney(bet)
				print('push')
			1:
				GameManager.changeMoney(bet * 2)
				print('you win')
			-1:
				print('you lose')
			_:
				push_error('somehow result is ' + str(result))
	$ContinueButton.show()
