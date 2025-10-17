import random

suits = ["Spades", "Hearts", "Clubs", "Diamonds"]
ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]


def createCards():
    cards = []
    for rank in ranks:
        value = (
            "A"
            if rank == "A"
            else (10 if rank == "J" or rank == "Q" or rank == "K" else int(rank))
        )
        for suit in suits:
            cards.append(
                {
                    "rank": rank,
                    "suit": suit,
                    "value": value,
                    "name": f"{rank} of {suit}",
                }
            )
    return cards


def getRandomCard(deck):
    index = random.randint(0, len(deck) - 1)
    return deck.pop(index)


def calcTotal(deck):
    # INCORRECT HANDLING OF ACES
    sum = 0
    soft = False
    aceCount = 0
    for card in deck:
        if card["value"] == "A":
            soft = True
            aceCount += 1
            sum += 1
        else:
            sum += card["value"]
    if soft:
        return (sum, sum + aceCount * 10)
    else:
        return sum


def turnSumIntoHumanWords(sum):
    if isinstance(sum, tuple):
        return f"either {sum[0]} or {sum[1]}"
    else:
        return sum


def setDealerRule():
    yn = input("Dealer stands at soft 17 (y) or hit at soft 17 (n)?")
    return yn == "y"


def printCards(deck):
    for card in deck:
        print(card)
    return


def isGameEndForPlayer(playerDeck):
    playerTotal = calcTotal(playerDeck)
    if isinstance(playerTotal, tuple):
        if playerTotal[0] > 21 and playerTotal[1] > 21:
            return True
    elif playerTotal > 21:
        return True
    return False


def isNaturalBlackjack(playerDeck):
    playerTotal = calcTotal(playerDeck)
    if isinstance(playerTotal, tuple):
        if playerTotal[0] == 21 or playerTotal[1] == 21:
            return True
    return False


def isGameEndForDealer(dealerDeck, hitOnSoft):
    dealerTotal = calcTotal(dealerDeck)
    if isinstance(dealerTotal, tuple):
        if dealerTotal[0] > 17 or dealerTotal[1] > 17:
            if hitOnSoft:
                if not (dealerTotal[0] < 17 or dealerTotal < 17):
                    return True
            else:
                return True
    elif dealerTotal > 17:
        return True
    return False


def isDealerBusted(dealerDeck):
    dealerTotal = calcTotal(dealerDeck)
    if isinstance(dealerTotal, tuple):
        if dealerTotal[0] > 21 and dealerTotal[1] > 21:
            return True
    elif dealerTotal > 21:
        return True
    return False


def compareHands(dealerDeck, playerDeck):
    dealerTotal = calcTotal(dealerDeck)
    if isinstance(dealerTotal, tuple):
        if dealerTotal[0] > dealerTotal[1] and dealerTotal[0] > 17:
            dealerTotal = dealerTotal[0]
        else:
            dealerTotal = dealerTotal[1]
    playerTotal = calcTotal(playerDeck)
    if isinstance(playerTotal, tuple):
        if playerTotal[0] > playerTotal[1]:
            playerTotal = playerTotal[0]
        else:
            playerTotal = playerTotal[1]
    if playerTotal > dealerTotal:
        return 1
    if playerTotal == dealerTotal:
        return 0
    else:
        return -1


def play(money):
    cards = createCards()

    dealerHand = []
    playerHand = []

    bet = int(input(f"Get yo bet in. You have {money} bucks."))
    while bet > money:
        bet = int(input(f"Nope, you only got {money} bucks. Can't bet higher."))
    money -= bet

    # initial draw
    playerHand.append(getRandomCard(cards))
    playerHand.append(getRandomCard(cards))
    dealerHand.append(getRandomCard(cards))
    dealerHand.append(getRandomCard(cards))

    hitOnSoft = setDealerRule()
    print(
        f"You have a {playerHand[0]['name']} and a {playerHand[1]['name']}, totaling at {turnSumIntoHumanWords(calcTotal(playerHand))}."
    )

    # check natural blackjack
    if isNaturalBlackjack(playerHand):
        money += bet * 3
        yn = input("You have natural blackjack! Play again? y/n")
        if yn == "y":
            play(money)
        return

    print(f"The dealer has a {dealerHand[1]['name']}.")

    # player draw loop
    standing = False
    while not (standing or isGameEndForPlayer(playerHand)):
        hitOrStand = input("Hit or stand? h/s")
        if hitOrStand == "h":
            playerHand.append(getRandomCard(cards))
            print(
                f"You drew a {playerHand[len(playerHand) - 1]['name']}, now totaling at {turnSumIntoHumanWords(calcTotal(playerHand))}"
            )
        else:
            standing = True
    if isGameEndForPlayer(playerHand):
        yn = input("You busted! You lose your bet. Play again? y/n")
        if yn == "y":
            play(money)
        return

    # dealer draw loop
    print(
        f"Dealer reveals face-down card being {dealerHand[0]['name']}, totaling at {turnSumIntoHumanWords(calcTotal(dealerHand))}."
    )
    while not isGameEndForDealer(dealerHand, hitOnSoft):
        dealerHand.append(getRandomCard(cards))
        print(
            f"Dealer draws a {dealerHand[len(dealerHand) - 1]['name']}, now totaling at {turnSumIntoHumanWords(calcTotal(dealerHand))}."
        )
    if isDealerBusted(dealerHand):
        money += bet * 2
        yn = input("The dealer is over! You win! Play again? y/n")
        if yn == "y":
            play(money)
        return

    # compare results
    result = compareHands(dealerHand, playerHand)
    print(
        f"Your sum is {turnSumIntoHumanWords(calcTotal(playerHand))}. Dealer's sum is {turnSumIntoHumanWords(calcTotal(dealerHand))}."
    )
    if result == 1:
        money += bet * 2
        print("You won!")
    if result == 0:
        money += bet
        print("It's a tie!")
    if result == -1:
        print("You lose!")
    yn = input("Play again? y/n")
    if yn == "y":
        play(money)
    return


money = 100
play(money)
