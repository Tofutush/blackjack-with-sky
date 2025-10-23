extends VBoxContainer
## meter for how much money you have. progressBar is capped at 1000

func _ready() -> void:
	updateBar(GameManager.money)
	GameManager.money_changed.connect(updateBar)

## updates progress bar with amount of money
func updateBar(amount: int) -> void:
	$ProgressBar.value = amount
	$Label.text = "$" + str(amount)
