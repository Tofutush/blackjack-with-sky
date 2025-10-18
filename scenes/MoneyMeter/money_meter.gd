extends VBoxContainer

func _ready() -> void:
	updateBar(GameManager.money)
	GameManager.money_changed.connect(updateBar)

func updateBar(amount: int) -> void:
	$ProgressBar.value = amount
	$Label.text = "$" + str(amount)
