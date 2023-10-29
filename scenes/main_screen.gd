extends Node2D

class_name MainScreen

@onready var tableaux = [
	$Tableaux/TableauPile1,
	$Tableaux/TableauPile2,
	$Tableaux/TableauPile3,
	$Tableaux/TableauPile4,
	$Tableaux/TableauPile5,
	$Tableaux/TableauPile6,
	$Tableaux/TableauPile7,
]

@onready var valid_drop_targets = [
	$Tableaux/TableauPile1,
	$Tableaux/TableauPile2,
	$Tableaux/TableauPile3,
	$Tableaux/TableauPile4,
	$Tableaux/TableauPile5,
	$Tableaux/TableauPile6,
	$Tableaux/TableauPile7,
	$Foundations/FoundationHeart,
	$Foundations/FoundationDiamond,
	$Foundations/FoundationSpade,
	$Foundations/FoundationClub,
	$Discard
]

func _ready() -> void:
	start_game()
		
func start_game() -> void:
	for card in get_tree().get_nodes_in_group("cards"):
		card.queue_free()
		
	await get_tree().create_timer(0).timeout
	
	$Stock.create_and_shuffle()
	
	if $CheatUI:
		$CheatUI.win.connect(self.win)
	
	for foundation in $Foundations.get_children():
		foundation.card_added.connect(self.check_victory)
	
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
			if not $Selection.is_empty():
				return
			var card = $Stock.take_top_card()
			$Discard.add_card(card)
			
		Regions.DISCARD:
			if not $Selection.is_empty():
				return
			print("Pickup from discard")
			$Discard.take_top_card()
			if not $Selection.is_empty():
				$Selection.put_back()
			$Selection.add_card_from(_card, $Discard)
			notify_selection_change($Discard)
			
		Regions.TABLEAU:
			if not $Selection.is_empty():
				return

			if _card.open:
				print("Pickup from tableau")
				var _tableau = find_tableau(_card)
				var _cards = _tableau.take_top_cards(_card)
				assert(_cards.size() >= 1)
				$Selection.add_cards_from(_cards, _tableau)
				notify_selection_change(_tableau)
			elif _card.at_top:
				_card.open = true
			

func notify_selection_change(_source: CardStack) -> void:
	for stack in valid_drop_targets:
		stack._on_selection_changed($Selection.get_cards(), _source)
		
func _on_double_click(_card) -> void:
	print("DC " + _card.debug_string())
	if not $Selection.is_empty():
		return
		
	match _card.get_region():
		Regions.DISCARD, Regions.TABLEAU, Regions.CURSOR:
			if try_move_to_foundation(_card):
				return
			if try_move_to_tableau(_card):
				return

func _on_right_click(_card) -> void:
	if $Selection.is_empty():
		return
	# try to drop onto a drop target
	var drop_target: CardStack = null
	for stack in valid_drop_targets:
		if stack.hovered and stack.get_node("DropoffSpot").active:
			drop_target = stack
			
	if drop_target:
		var cards = $Selection.take_cards()
		drop_target.add_cards(cards)
		notify_selection_change(null)
	else:
		# We're not above a valid drop target - return cards to source
		print("Dropping card(s)")
		if not $Selection.is_empty():
			$Selection.put_back()
			notify_selection_change(null)

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
				elif _card.get_region() == Regions.CURSOR:
					print("Move from cursor to foundation")
					$Selection.take_top_card()
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
				elif _card.get_region() == Regions.CURSOR:
					pass # the card has already been removed from its previous location
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
		if tableau.contains(_card):
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
			
func check_victory():
	for foundation in $Foundations.get_children():
		if foundation.get_current_value() < 13:
			return
	win()
		
func win() -> void:
	$Audio/VictoryFanfare.play()
	$UI.congratulate()

func _get_configuration_warnings() -> PackedStringArray:
	var results = PackedStringArray()
	if get_tree().get_nodes_in_group("cards").size() != 52:
		results.append("Number of cards is not 52")
	return results
