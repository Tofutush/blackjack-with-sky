extends Control

const deckDisplayScene = preload("res://scenes/DeckDisplay/deck_display.tscn")
const chipsScene = preload("res://scenes/Chips/chips.tscn")

const DECK_INITIAL_POS = Vector2(12, 540)
const CHIP_INITIAL_POS = Vector2(460, 540)

var mainDeck: Deck
var dealerHand: Deck
var playerHands: Array[Deck]
var playerDeckDisplays: Array[DeckDisplay]
var playerChipDisplays: Array[Chips]
var playerIdx: int # what hand is the player on, for splitting

var bet: int
var insuranceBet: int
var insuring: bool
var splittingAces: bool # only true if strict splitting is on

func _ready() -> void:
	newGame()

func newGame() -> void:
	$ContinueButton.hide()
	$InsuranceChips.hide()
	$PlayerButtons.disableButtons()
	$DealerDeckDisplay.clear()
	for child in $PlayerDeckDisplays.get_children():
		child.queue_free()
	for child in $PlayerChipDisplays.get_children():
		child.queue_free()
	$Bet.startBetting(GameManager.money, "bet")

func endGame() -> void:
	# this is the TRUE endGame, when all hands have been played
	# check insurance on game end bc it carries out regardless of outcome of main game
	if insuring:
		# the dealer would not draw any more cards had they natural bj, so it's safe to call this
		if dealerHand.isNaturalBlackjack():
			print('insure bet won')
			GameManager.changeMoney(insuranceBet * 3)
	$PlayerButtons.disableButtons()
	$ContinueButton.show()

func endHand() -> void:
	# this is when you finish playing a hand
	if playerIdx == playerHands.size() - 1:
		# at last index, we've played through all of our hands
		dealerDrawLoop()
	else:
		playerDeckDisplays[playerIdx].hide()
		playerIdx += 1
		playerDeckDisplays[playerIdx].show()
		$PlayerButtons.enableButtons()
		$PlayerButtons.disableButton('split')
		# you can only buy insurance at the very start
		$PlayerButtons.disableButton('insurance')

func _on_continue_button_pressed() -> void:
	newGame()

func _on_bet_bet_submitted(amount: int, purpose: String) -> void:
	match purpose:
		"bet":
			bet = amount
			# subtract bet here
			GameManager.changeMoney(-bet)
			play()
		"insurance":
			insuranceBet = amount
			GameManager.changeMoney(-insuranceBet)
			$InsuranceChips.setChips(insuranceBet)
		_:
			push_error('unknown bet slider purpose' + purpose)

func play() -> void:
	# create deck
	mainDeck = GameManager.createDeck()

	# create the 3 player things: Deck, DeckDisplay, Chips; and inits
	playerHands = [Deck.new([])]
	playerDeckDisplays = [deckDisplayScene.instantiate()]
	$PlayerDeckDisplays.add_child(playerDeckDisplays[0])
	playerDeckDisplays[0].position = DECK_INITIAL_POS

	playerChipDisplays = [chipsScene.instantiate()]
	$PlayerChipDisplays.add_child(playerChipDisplays[0])
	playerChipDisplays[0].setChips(bet)
	playerChipDisplays[0].position = CHIP_INITIAL_POS

	playerIdx = 0
	playerHands[0].linkDisplay(playerDeckDisplays[0])

	# dealer
	dealerHand = Deck.new([])
	dealerHand.linkDisplay($DealerDeckDisplay)

	# deal initial cards
	#playerHands[0].addCard(mainDeck.drawRandom())
	#playerHands[0].addCard(mainDeck.drawRandom())
	playerHands[0].addCard(mainDeck.drawRigged('3'))
	playerHands[0].addCard(mainDeck.drawRigged('3'))
	dealerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom(), true)
	#dealerHand.addCard(mainDeck.drawRigged('A'))
	#dealerHand.addCard(mainDeck.drawRigged('10'), true)

	# check natural blackjack
	if playerHands[0].isNaturalBlackjack():
		print('natural blackjack! you win!')
		GameManager.changeMoney(floor(bet * 1.5))
		endGame()
		return

	# enable them first, then disable split / insurance as fit
	$PlayerButtons.enableButtons()

	# check split
	checkSplit()

	# check insurance
	if dealerHand.getCard(0).rank == 'A':
		$PlayerButtons.enableButton('insurance')
		if bet == 1:
			$PlayerButtons.disableButton('insurance')
			$PlayerButtons.setButtonTooltip('insurance', "Bet too low.")
		if GameManager.money == 0:
			$PlayerButtons.disableButton('insurance')
			$PlayerButtons.setButtonTooltip('insurance', "Not enough money.")
	else:
		$PlayerButtons.disableButton('insurance')

	return

func checkSplit() -> void:
	if GameManager.strictSplitting && playerHands.size() == 4:
		$PlayerButtons.disableButton('split')
		$PlayerButtons.setButtonTooltip('split', 'You have 4 hands already.')
		return
	if playerHands[playerIdx].isSplittable():
		$PlayerButtons.enableButton('split')
		if GameManager.money < bet:
			$PlayerButtons.disableButton('split')
			$PlayerButtons.setButtonTooltip('split', 'Not enough money.')
	else:
		$PlayerButtons.disableButton('split')

# 6 player options. these signals are middleman signals from $PlayerButtons
func _on_player_hit() -> void:
	if playerIdx == 1: playerHands[playerIdx].addCard(mainDeck.drawRigged('3'))
	else: playerHands[playerIdx].addCard(mainDeck.drawRandom())
	$PlayerButtons.disableButton('double down')
	checkSplit()
	if playerHands[playerIdx].isBusted():
		print('you bust! you lose!')
		endHand()

func _on_player_double_down() -> void:
	# double down: bet double, hit once more, and stand
	# can only be done on round 1 just like insurance, so consider moving it out of the PlayerButtons list?
	if GameManager.money < bet:
		# the button should be disabled if you cant double down
		push_error('not enough money to double down')
	GameManager.changeMoney(-bet)
	bet *= 2
	playerChipDisplays[playerIdx].doubleChips()
	playerHands[playerIdx].addCard(mainDeck.drawRandom())
	$PlayerButtons.disableButtons()
	if playerHands[playerIdx].isBusted():
		print('you bust! you lose!')
		endHand()
		return
	endHand()

func _on_player_stand() -> void:
	$PlayerButtons.disableButtons()
	endHand()

func _on_player_surrender() -> void:
	# 2.0 to get rid of that warning while avoiding that stupid line of code
	GameManager.changeMoney(int(floor(bet / 2.0)))
	endHand()

func _on_player_insurance() -> void:
	insuring = true
	$Bet.startBetting(int(floor(bet / 2.0)), 'insurance')
	$PlayerButtons.disableButton('insurance')

func _on_player_split() -> void:
	GameManager.changeMoney(-bet)

	# for each hand we split, we need a Deck, a DeckDisplay, and a Chips.
	# this is Deck
	playerHands.append(playerHands[playerIdx].split())
	var newPlayerHand = playerHands[playerHands.size() - 1]

	# DeckDisplay
	playerDeckDisplays.append(deckDisplayScene.instantiate())
	var newDeckDisplay = playerDeckDisplays[playerDeckDisplays.size() - 1]
	newDeckDisplay.position = DECK_INITIAL_POS
	newDeckDisplay.hide()
	$PlayerDeckDisplays.add_child(newDeckDisplay)

	# link them together
	newPlayerHand.linkDisplay(newDeckDisplay)

	# Chips
	playerChipDisplays.append(chipsScene.instantiate())
	var newChipDisplay = playerChipDisplays[playerChipDisplays.size() - 1]
	newChipDisplay.position = CHIP_INITIAL_POS + Vector2(40, 40) * (playerChipDisplays.size() - 1)
	$PlayerChipDisplays.add_child(newChipDisplay)
	newChipDisplay.setChips(bet)

	if GameManager.strictSplitting && newPlayerHand.getCard(0).rank == 'A':
		splittingAces = true

	$PlayerButtons.disableButton('split')

func dealerDrawLoop() -> void:
	$DealerDeckDisplay.turnLastBackCard()
	while not dealerHand.isEndForDealer():
		dealerHand.addCard(mainDeck.drawRandom())
	if dealerHand.isBusted():
		GameManager.changeMoney(bet * 2)
		print('dealer over, you win')
	else:
		var result = playerHands[playerIdx].compareValue(dealerHand)
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
