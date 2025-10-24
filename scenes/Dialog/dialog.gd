extends Control
class_name Dialog
## dialog class for sky talking

@onready var rich_text_label: RichTextLabel = $RichTextLabel ## dialog text
@onready var timer: Timer = $Timer ## timer for typing

signal dialog_finished ## emit after a dialog is done

var sprite: SkyTalk ## the sprite of sky, to change his expressions

var lines: Array = []
var currentLine := 0
var isDialogging := false
var isAnimating := false

func linkSprite(sprite1: SkyTalk) -> void:
	sprite = sprite1

## show dialog with an array of lines
func showDialog(lines1: Array):
	lines = lines1
	currentLine = 0
	showMessage()

## shows a message in the dialog. can bbcode
func showMessage() -> void:
	if currentLine >= lines.size():
		isDialogging = false
		hide()
		dialog_finished.emit()
		return
	isDialogging = true
	if sprite:
		var parsed = lines[currentLine].rsplit('@')
		if parsed.size() == 2:
			rich_text_label.text = parsed[1]
			sprite.changeSprite(parsed[0])
		else: rich_text_label.text = parsed[0]
	else:
		rich_text_label.text = lines[currentLine]
	show()
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

## return empty string if singular, 's' if plural
static func plural(num: int):
	if num == 1: return ''
	return 's'
