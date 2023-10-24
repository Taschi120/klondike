extends CardStack

class_name Discard

@onready var tableaux = [
	$Tableaux/TableauPile1,
	$Tableaux/TableauPile2,
	$Tableaux/TableauPile3,
	$Tableaux/TableauPile4,
	$Tableaux/TableauPile5,
	$Tableaux/TableauPile6,
	$Tableaux/TableauPile7,
]

var selected_card = null

func _ready() -> void:
	$Stock.create_and_shuffle()
	
	# put cards on tableau
	for tableau_num in range(7):
		var stack = tableaux[tableau_num]
		# deal n face-down cards
		for card_num in range(tableau_num):
			var card = $Stock.take_top_card()
			stack.add_card(card)
		# and deal one face-open card
		var card = $Stock.take_top_card()
		card.open = true
		card.at_top = true
		stack.add_card(card)

func _on_card_clicked(_card) -> void:
	print(_card.debug_string())
	
	
	match _card.get_region():
		Regions.DRAW:
			var card = $Stock.take_top_card()
			$Discard.add_card(card)
			
		Regions.DISCARD:
			selected_card = _card
			
		Regions.TABLEAU:
			if _card.open:
				selected_card = _card
			elif _card.at_top:
				_card.open = true
			

func _on_double_click(_card) -> void:
	print(_card.debug_string())
	
	match _card.get_region():
		Regions.DISCARD, Regions.TABLEAU:
			if try_move_to_foundation(_card):
				return
			if try_move_to_tableau(_card):
				return

func try_move_to_foundation(_card) -> bool:
	if not _card.open:
		return false
	for foundation in $Foundations.get_children():
		if foundation.suit == _card.suit:
			if foundation.get_current_value() + 1 == _card.value:
				if _card.get_region() == Regions.DISCARD:
					print("Move from discard to foundation")
					$Discard.take_top_card()
				elif _card.get_region() == Regions.TABLEAU:
					print("Move from tableau to foundation")
					remove_card_from_tableaux(_card)
				else:
					assert(false)
				foundation.add_card(_card)
				return true
	return false
	
func try_move_to_tableau(_card) -> bool:
	if not _card.open:
		return false
	for tableau in $Tableaux.get_children():
		
		if tableau.is_empty():
			continue
		var top_card = tableau.peek()
		if top_card == null && _card.value == 13:
			# move king to empty slot
			if _card.get_region() == Regions.DISCARD:
				$StockAndDiscard.remove_top_from_discard()
			elif _card.get_region() == Regions.TABLEAU:
				remove_card_from_tableaux(_card)
			else:
				assert(false)
			_card.at_top = true
			tableau.add_card(_card)
			return true
			
		if top_card != null and \
			top_card.open and \
			_card.value == top_card.value -1 and \
			_card.get_color() != top_card.get_color():
				top_card.at_top = false
				if _card.get_region() == Regions.DISCARD:
					$Discard.take_top_card()
				elif _card.get_region() == Regions.TABLEAU:
					remove_card_from_tableaux(_card)
				else:
					assert(false)
				_card.at_top = true

				tableau.add_card(_card)
				return true
	
	return false
	
func remove_card_from_tableaux(_card):
	for tableau in tableaux:
		if not tableau.is_empty() and _card == tableau.peek():
			tableau.take_top_card()

func find_tableau(_card):
	assert(_card.get_region() == Regions.TABLEAU)
	for tableau in tableaux:
		if _card in tableau.get_children():
			return tableau
			
	assert(false)
	return null

func cycle_discard():
	while not $Discard.is_empty():
		var card = $Discard.take_top_card()
		card.set_deferred("open", false)
		card.set_deferred("at_top", false)
		$Stock.add_card(card)
			
		if not $Stock.is_empty():
			$Stock.peek().set_deferred("at_top", true)
			
