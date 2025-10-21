extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

var bet: int
var insuranceBet: int
var insuring: bool

func _ready() -> void:
	newGame()

func newGame() -> void:
	$ContinueButton.hide()
	$MainChips.hide()
	$SplitChips.hide()
	$InsuranceChips.hide()
	$Bet.startBetting(GameManager.money, "bet")
	$PlayerButtons.disableButtons()
	$PlayerDeckDisplay.clear()
	$DealerDeckDisplay.clear()

func endGame() -> void:
	print(insuring)
	# check insurance on game end bc it carries out regardless of outcome of main game
	if insuring:
		# the dealer would not draw any more cards had they natural bj, so it's safe to call this
		if dealerHand.isNaturalBlackjack():
			print('insure bet won')
			GameManager.changeMoney(insuranceBet * 3)
	$PlayerButtons.disableButtons()
	$ContinueButton.show()

func _on_continue_button_pressed() -> void:
	newGame()

func _on_bet_bet_submitted(amount: int, purpose: String) -> void:
	match purpose:
		"bet":
			bet = amount
			# subtract bet here
			GameManager.changeMoney(-bet)
			$MainChips.setChips(bet)
			play()
		"insurance":
			insuranceBet = amount
			GameManager.changeMoney(-insuranceBet)
			$InsuranceChips.setChips(insuranceBet)
		_:
			push_error('unknown bet slider purpose' + purpose)

func play() -> void:
	# create decks
	mainDeck = GameManager.createDeck()
	playerHand = Deck.new([])
	playerHand.linkDisplay($PlayerDeckDisplay)
	dealerHand = Deck.new([])
	dealerHand.linkDisplay($DealerDeckDisplay)

	# deal initial cards
	playerHand.addCard(mainDeck.drawRandom())
	playerHand.addCard(mainDeck.drawRandom())
	#dealerHand.addCard(mainDeck.drawRandom())
	#dealerHand.addCard(mainDeck.drawRandom(), true)
	dealerHand.addCard(mainDeck.drawRigged('A'))
	dealerHand.addCard(mainDeck.drawRigged('10'), true)

	# check natural blackjack
	if playerHand.isNaturalBlackjack():
		print('natural blackjack! you win!')
		GameManager.changeMoney(floor(bet * 1.5))
		endGame()
		return

	# check split
	if playerHand.getCard(0).compareRank(playerHand.getCard(1)):
		print('splittable')

	# check insurance
	if dealerHand.getCard(0).rank == 'A':
		$PlayerButtons.enableButton('insurance')
		if bet == 1:
			$PlayerButtons.disableButton('insurance')
			$PlayerButtons.setButtonTooltip('insurance', "Bet too low.")
		if GameManager.money == 0:
			$PlayerButtons.disableButton('insurance')
			$PlayerButtons.setButtonTooltip('insurance', "Not enough money.")

	# player draw
	$PlayerButtons.enableButtons()

	return

# 6 player options. these signals are middleman signals from $PlayerButtons
func _on_player_hit() -> void:
	playerHand.addCard(mainDeck.drawRandom())
	$PlayerButtons.disableButton('double down')
	if playerHand.isBusted():
		print('you bust! you lose!')
		endGame()

func _on_player_double_down() -> void:
	# double down: bet double, hit once more, and stand
	# can only be done on round 1 just like insurance, so consider moving it out of the PlayerButtons list?
	if GameManager.money < bet:
		# the button should be disabled if you cant double down
		push_error('not enough money to double down')
	GameManager.changeMoney(-bet)
	bet *= 2
	$MainChips.doubleChips()
	playerHand.addCard(mainDeck.drawRandom())
	$PlayerButtons.disableButtons()
	if playerHand.isBusted():
		print('you bust! you lose!')
		endGame()
		return
	dealerDrawLoop()

func _on_player_stand() -> void:
	$PlayerButtons.disableButtons()
	# dealer draw
	dealerDrawLoop()

func _on_player_surrender() -> void:
	# 2.0 to get rid of that warning while avoiding that stupid line of code
	GameManager.changeMoney(int(floor(bet / 2.0)))
	endGame()

func _on_player_insurance() -> void:
	insuring = true
	$Bet.startBetting(int(floor(bet / 2.0)), 'insurance')
	$PlayerButtons.disableButton('insurance')

func _on_player_split() -> void:
	pass # Replace with function body.

func dealerDrawLoop() -> void:
	$DealerDeckDisplay.turnLastBackCard()
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
	endGame()
