extends Node

var Constants = preload("res://scripts/constants.gd")

signal clicked
signal double_clicked

var open = false: set = set_open

# indicates if this is the topmost card of its stack
var at_top = false: get = is_at_top

const HEART = "heart"
const DIAMOND = "diamond"
const SPADE = "spade"
const CLUB = "club"



var suit = SPADE: set = set_suit
var value = 1: set = set_value

var region = Constants.Regions.DRAW

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
	
func get_region_name() -> String:
	match region:
		Constants.Regions.DRAW:
			return "Draw Pile"
		Constants.Regions.DISCARD:
			return "Discard Pile"
		Constants.Regions.TABLEAU:
			return "Tableau"
		Constants.Regions.FOUNDATION:
			return "Foundation"
		Constants.Regions.CURSOR:
			return "Cursor"
			
	return "Unknown (" + str(region) + ")"

func get_color() -> String:
	if suit == "club" || suit == "spade":
		return "black"
	else:
		return "red"
		
func is_at_top():
	var p = get_parent()
	if p == null:
		return false
	var siblings = p.get_children()
	return self == siblings[siblings.size() - 1]

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
		+ " @ " + get_region_name() + ")"
	return result

func clickable():
	match region:
		Constants.Regions.DRAW:
			return at_top
		Constants.Regions.DISCARD:
			return at_top
		Constants.Regions.FOUNDATION:
			return false
		Constants.Regions.TABLEAU:
			return open or at_top
	return false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# this'll need to be changed for picking up stacks
	if not clickable():
		return
		
	if event is InputEventMouseButton and event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
		print("dc")
		double_clicked.emit(self)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)
