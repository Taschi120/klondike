extends CardStack

class_name Stock

@export var main_scene: MainScreen = null

signal needs_cycling

var card_scene = load("res://scenes/game/card.tscn")

# number of the most recent frame when a card was picked up.
# we need this info so one click cannot trigger both pickup
# of the last card in the stack and cycling the discard
var last_draw_frame = 0

func take_top_card() -> Card:
	last_draw_frame = Engine.get_process_frames()
	$Audio/DealCard.play()
	return super.take_top_card()
	

func create_and_shuffle() -> void:
	$Audio/Shuffle.play()
	var unshuffled_pile = []
	for suit in ["heart", "diamond", "spade", "club"]:
		for value in range(1, 14):
			var card = card_scene.instantiate()
			card.suit = suit
			card.value = value
			card.open = false
			card.at_top = false
			
			card.picked_up.connect(main_scene._on_card_clicked)
			card.double_clicked.connect(main_scene._on_double_click)
			card.released.connect(main_scene._on_right_click)
			unshuffled_pile.append(card)
			
	var shuffled_pile = []
	
	while not unshuffled_pile.is_empty():
		var pos = randi() % unshuffled_pile.size()
		var card = unshuffled_pile[pos]
		unshuffled_pile.remove_at(pos)
		
		add_card(card)

func get_region():
	return Regions.DRAW

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and get_tree().root.get_node("MainScreen").get_node("Selection").is_empty() \
	and is_empty() \
	and Engine.get_process_frames() > last_draw_frame:
		print("Stack empty")
		needs_cycling.emit()
