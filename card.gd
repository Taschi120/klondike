extends Node

var Constants = preload("res://scripts/constants.gd")

signal clicked

var open = false: set = set_open

# indicates if this is the topmost card of its stack
var at_top = false

const HEART = "heart"
const DIAMOND = "diamond"
const SPADE = "spade"
const CLUB = "club"



var suit = SPADE: set = set_suit
var value = 1: set = set_value

var location = Constants.Location.DRAW

func set_open(_open: bool) -> void:
	open = _open
	if open:
		$CardbackSprite.visible = false
		$MainSprite.visible = true
	else:
		$CardbackSprite.visible = true
		$MainSprite.visible = false
		
func set_suit(_suit):
	suit = _suit
	$MainSprite.frame_coords.y = get_row(suit)

func set_value(_value):
	assert(_value >= 1)
	assert(_value <= 13)
	value = _value
	$MainSprite.frame_coords.x = value - 1

		
func get_row(_suit: String) -> int:
	if _suit == DIAMOND:
		return 0
	if _suit == HEART:
		return 1
	if _suit == CLUB:
		return 2
	elif _suit == SPADE:
		return 3
	assert(false)
	return 5

func debug_string() -> String:
	var result = ""
	if value == 1:
		result += "Ace"
	elif value == 11:
		result += "Jack"
	elif value == 12:
		result += "Queen"
	elif value == 13:
		result += "King"
	else:
		result += str(value)
		
	result += " of "
	result += suit + "s (" \
		+ ("face-up" if open else "face-down") \
		+ ")"
	return result


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not at_top:
		return
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)
