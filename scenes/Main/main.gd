extends Control

var mainDeck: Deck
var dealerHand: Deck
var playerHand: Deck
var playerHand2: Deck

func _ready() -> void:
	play()

func play() -> void:
	# create decks
	mainDeck = GameManager.createDeck()
	playerHand = Deck.new([])
	dealerHand = Deck.new([])
	
	# bets in
	$Bet
	
	# deal initial cards
	playerHand.addCard(mainDeck.drawRandom())
	playerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	dealerHand.addCard(mainDeck.drawRandom())
	$PlayerCards.text = playerHand.getCard(0).toText() + ", " + playerHand.getCard(1).toText() + ", value " + playerHand.getValueString()
	$DealerCards.text = dealerHand.getCard(0).toText() + ", " + dealerHand.getCard(1).toText() + ", value " + dealerHand.getValueString()
	
	# check natural blackjack
	if isNaturalBlackjack(playerHand):
		print('natural blackjack! you win!')
	
	# check

func isNaturalBlackjack(deck: Deck) -> bool:
	var value = deck.getValue()
	return value['soft'] && value['value'].has(21)
