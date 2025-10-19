extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

var bet: int

func _ready() -> void:
	$Bet.startBetting()
	$PlayerButtons.disableButtons()

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
	dealerHand.addCard(mainDeck.drawRandom())

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

func _on_player_double_down() -> void:
	if GameManager.money < bet:
		# the button should be disabled if you cant double down
		push_error('not enough money to double down')
	# double down: bet double, hit once more, and stand
	GameManager.changeMoney(-bet)
	playerHand.addCard(mainDeck.drawRandom())
	$PlayerButtons.disableButtons()
	# see if you can extract this into its own function so you can reuse it
	if playerHand.isBusted():
		print('you bust! you lose!')
		# round ends

func _on_player_stand() -> void:
	$PlayerButtons.disableButtons()
	# dealer draw

func _on_player_surrender() -> void:
	# 2.0 to get rid of that warning while avoiding that stupid line of code
	GameManager.changeMoney(int(floor(bet / 2.0)))
	$PlayerButtons.disableButtons()
	# round ends

func dealerDrawLoop():
	pass
