extends Node

class_name Card

signal picked_up
signal double_clicked
signal released

var open = false: set = set_open

# indicates if this is the topmost card of its stack
var at_top = false: get = is_at_top

const HEART = "heart"
const DIAMOND = "diamond"
const SPADE = "spade"
const CLUB = "club"

var suit = SPADE: set = set_suit
var value = 1: set = set_value

func get_region() -> int:
	return get_parent().get_parent().get_region()

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
	match get_region():
		Regions.DRAW:
			return "Draw Pile"
		Regions.DISCARD:
			return "Discard Pile"
		Regions.TABLEAU:
			return "Tableau"
		Regions.FOUNDATION:
			return "Foundation"
		Regions.CURSOR:
			return "Cursor"
			
	return "Unknown (" + str(get_region()) + ")"

func get_color() -> String:
	if suit == "club" || suit == "spade":
		return "black"
	else:
		return "red"
		
func is_at_top():
	var p = get_parent()
	assert(p != null)
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
	match get_region():
		Regions.DRAW:
			return at_top
		Regions.DISCARD:
			return at_top
		Regions.FOUNDATION:
			return false
		Regions.TABLEAU:
			if at_top and not open:
				return true
			elif open:
				return true
		Regions.CURSOR:
			# when a card is on the cursor, it needs to receive double-click and right-click events,
			# but normal clicks need to be ignored and passed to the stack below (if there is one)
			return true
	return false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# this'll need to be changed for picking up stacks
	if not clickable():
		return
		
	var _parent = get_parent()
	if _parent:
		var __parent = _parent.get_parent()
		if __parent:
			var dropoff_spot = __parent.get_node("DropoffSpot")
			if dropoff_spot and dropoff_spot.active:
				return
		
	if event is InputEventMouseButton \
		and event.double_click \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and clickable \
		and get_region() != Regions.DRAW:
			
		print("dc")
		double_clicked.emit(self)
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			picked_up.emit(self)
		elif event.is_released():
			released.emit(self)
