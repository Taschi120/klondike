extends Node2D

var Constants = preload("res://scripts/constants.gd")

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
	$StockAndDiscard.create_and_shuffle()
	
	# put cards on tableauc
	for tableau_num in range(7):
		var stack = tableaux[tableau_num]
		# deal n face-down cards
		for card_num in range(tableau_num):
			var card = $StockAndDiscard.draw_and_remove()
			card.region = Constants.Regions.TABLEAU
			stack.add_card(card)
		# and deal one face-open card
		var card = $StockAndDiscard.draw_and_remove()
		card.open = true
		card.at_top = true
		card.region = Constants.Regions.TABLEAU
		stack.add_card(card)

func _on_card_clicked(_card) -> void:
	print(_card.debug_string())
	
	
	match _card.region:
		Constants.Regions.DRAW:
			var card = $StockAndDiscard.draw_and_remove()
			$StockAndDiscard.add_to_discard(card)
			
		Constants.Regions.DISCARD:
			selected_card = _card
			
		Constants.Regions.TABLEAU:
			if _card.open:
				selected_card = _card
			elif _card.at_top:
				_card.open = true
			

func _on_double_click(_card) -> void:
	print(_card.debug_string())
	
	match _card.region:
		Constants.Regions.DISCARD, Constants.Regions.TABLEAU:
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
				if _card.region == Constants.Regions.DISCARD:
					$StockAndDiscard.remove_top_from_discard()
				elif _card.region == Constants.Regions.TABLEAU:
					remove_card_from_tableaux(_card)
				else:
					assert(false)
				_card.at_top = false # cards in foundation can't be interacted  with
				_card.region = Constants.Regions.FOUNDATION
				foundation.add_child(_card)
				return true
	return false
	
func try_move_to_tableau(_card) -> bool:
	if not _card.open:
		return false
	for tableau in $Tableaux.get_children():
		var top_card = tableau.get_top_card()
		if top_card == null && _card.value == 13:
			# move king to empty slot
			if _card.region == Constants.Regions.DISCARD:
				$StockAndDiscard.remove_top_from_discard()
			elif _card.region == Constants.Regions.TABLEAU:
				remove_card_from_tableaux(_card)
			else:
				assert(false)
			_card.at_top = true
			_card.region = Constants.Regions.TABLEAU
			tableau.add_card(_card)
			return true
			
		if top_card != null and \
			top_card.open and \
			_card.value == top_card.value -1 and \
			_card.get_color() != top_card.get_color():
				top_card.at_top = false
				if _card.region == Constants.Regions.DISCARD:
					$StockAndDiscard.remove_top_from_discard()
				elif _card.region == Constants.Regions.TABLEAU:
					remove_card_from_tableaux(_card)
				else:
					assert(false)
				_card.at_top = true
				_card.region = Constants.Regions.TABLEAU
				tableau.add_card(_card)
				return true
	
	return false
	
func remove_card_from_tableaux(_card):
	for tableau in tableaux:
		if _card in tableau.get_children():
			tableau.remove_top_card()

func find_tableau(_card):
	assert(_card.region == Constants.Regions.TABLEAU)
	for tableau in tableaux:
		if _card in tableau.get_children():
			return tableau
			
	assert(false)
	return null
