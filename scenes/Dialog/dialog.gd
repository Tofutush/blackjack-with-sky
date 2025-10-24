extends Control
class_name Dialog
## dialog class for sky talking

@onready var rich_text_label: RichTextLabel = $PanelContainer/RichTextLabel ## dialog text
@onready var timer: Timer = $Timer ## timer for typing

var lines: Array[String] = []
var currentLine := 0
var isDialogging := false
var isAnimating := false

func showDialog(lines1: Array[String]):
	lines = lines1
	currentLine = 0
	showMessage()

## shows a message in the dialog. can bbcode
func showMessage() -> void:
	if currentLine >= lines.size():
		isDialogging = false
		hide()
		return
	isDialogging = true
	rich_text_label.text = lines[currentLine]
	if GameManager.textAnimation:
		isAnimating = true
		rich_text_label.visible_characters = 0
		timer.start()
	else:
		showMessageImmediately()

## displays entire message and ends isAnimating
func showMessageImmediately() -> void:
	timer.stop()
	rich_text_label.text = lines[currentLine]
	rich_text_label.visible_characters = -1
	isAnimating = false

func _on_timer_timeout() -> void:
	if rich_text_label.visible_characters < rich_text_label.text.length():
		rich_text_label.visible_characters += 1
	else:
		timer.stop()
		isAnimating = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog"):
		if isAnimating:
			showMessageImmediately()
		else:
			currentLine += 1
			showMessage()
