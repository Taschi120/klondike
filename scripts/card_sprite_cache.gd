extends Node

class_name CardSpriteCache

const FILENAME_PATTERN := "res://assetpacks/cards/Standard 52 Cards/solitaire/individuals/%s/%s_%s.png"

var sprites = {}


func _init() -> void:
	for suit in ["heart", "spade", "club", "diamond"]:
		var sprites_for_suit = []
		for num in range(1, 14):
			var sprite = load(FILENAME_PATTERN % [suit, str(num), suit])
			sprites_for_suit.append(sprite)
		
		sprites[suit] = sprites_for_suit
