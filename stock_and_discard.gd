extends Node

@export var main_scene: Node2D = null

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
			
			card.clicked.connect(main_scene._on_card_clicked)
			card.double_clicked.connect(main_scene._on_double_click)
			unshuffled_pile.append(card)
			
	var shuffled_pile = []
	
	while not unshuffled_pile.is_empty():
		var pos = randi() % unshuffled_pile.size()
		var card = unshuffled_pile[pos]
		unshuffled_pile.remove_at(pos)
		
		$Stock/CardStack.add_card(card)
	
func draw_and_remove():

	var _card = $Stock/CardStack.take_top_card()
	_card.at_top = false # should be re-set by whoever is taking the card
	
	# make the new top card clickable
	if not $Stock/CardStack.is_empty():
		_card = $Stock/CardStack.peek()
		_card.set_deferred("at_top", true)
	
	return _card

func add_to_discard(_card) -> void:
	# make the old top card unclickable
	if not $Discard/CardStack.is_empty():
		$Discard/CardStack.peek().set_deferred("at_top", false)
		
	# add the new card
	_card.set_deferred("open", true)
	_card.set_deferred("at_top", true)
	$Discard/CardStack.add_card(_card)
	_card.position = Vector2.ZERO

func remove_top_from_discard():
	return $Discard/CardStack.take_top_card()

func _on_empty_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		if $Stock/CardStack.is_empty():
			print("Stock clicked - ignore, not empty")
			return
		else:
			print("Empty stock clicked - cycling")
			
			while not $Discard/CardStack.is_empty():
				var card = $Discard/CardStack.take_top_card()
				card.set_deferred("open", false)
				card.set_deferred("at_top", false)
				$Stock/CardStack.add_card(card)
			
			if not $Stock/CardStack.is_empty():
				$Stock/CardStack.peek().set_deferred("at_top", true)

