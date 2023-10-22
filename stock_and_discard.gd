extends Node

@export var main_scene: Node2D = null

var Constants = preload("res://scripts/constants.gd")

var card_scene = load("res://card.tscn")

func create_and_shuffle():
	var unshuffled_pile = []
	for suit in ["heart", "diamond", "spade", "club"]:
		for value in range(1, 13):
			var card = card_scene.instantiate()
			card.suit = suit
			card.value = value
			card.open = false
			card.at_top = false
			card.location = Constants.Location.DRAW
			
			card.clicked.connect(main_scene._on_card_clicked)
			unshuffled_pile.append(card)
			
	var shuffled_pile = []
	
	while not unshuffled_pile.is_empty():
		var pos = randi() % unshuffled_pile.size()
		var card = unshuffled_pile[pos]
		unshuffled_pile.remove_at(pos)
		
		$Stock.add_child(card)
	
func draw_and_remove():
	var cards = $Stock.get_children()
	var idx = cards.size() - 1
	
	# if idx is exactly zero, the only element in the stack is the "Empty" sprite!
	assert(idx > 0)
	
	var card = cards[idx]
	$Stock.remove_child(card)
	card.at_top = false # should be re-set by whoever is taking the card
	
	# make the new top card clickable
	cards = $Stock.get_children()
	idx = cards.size() - 1
	if (idx <= 0):
		pass # TODO handle empty clickspot here
	else:
		cards[idx].at_top = true
	
	return card

func add_to_discard(card) -> void:
	# make the old top card unclickable
	var child_count = $Discard.get_child_count()
	if child_count >= 2:
		$Discard.get_child(child_count - 1).at_top = false
		
	# add the new card
	card.open = true
	card.location = Constants.Location.DISCARD
	$Discard.add_child(card)
	card.location = Vector2.ZERO


func _on_empty_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		if $Stock.get_child_count() > 1:
			print("Stock clicked - ignore, not empty")
			return
		else:
			print("Empty stock clicked - cycling")
			
			var cards = []
			
			while $Discard.get_child_count() >= 2:
				var card = $Discard.get_child($Discard.get_child_count() - 1)
				$Discard.remove_child(card)
				card.open = false
				card.at_top = false
				card.location = Constants.Location.DRAW
				$Stock.add_child(card)
			
			if $Stock.get_child_count() >= 2:
				$Stock.get_child($Stock.get_child_count() - 1).at_top = true
