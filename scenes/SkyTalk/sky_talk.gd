extends Control
class_name SkyTalk
## used in the intro, game end, and game win; when sky is just talking and nothing else

const sprites: Dictionary = {
	"normal": preload("res://assets/sky.png")
}

func _ready() -> void:
	$BlackScreen.fadeOut()

## changes sky's sprite
func changeSprite(textureName: String) -> void:
	$Sky.texture = sprites[textureName]
