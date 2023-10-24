extends Node2D

func add_card(card):
	var top_card = 	get_top_card();
	if top_card != null:
		top_card.at_top = false
		
	card.set_deferred("at_top", true)
	add_child(card)
	reorg_stack()

	
func get_top_card():
	var child_count = get_child_count()
	if child_count >= 2:
		return get_child(child_count - 1)
	else:
		return null
	
func remove_top_card():
	var card = get_top_card()
	remove_child(card)
	
	var top_card = get_top_card()
	if top_card != null:
		top_card.set_deferred("at_top", true)
	
	reorg_stack()
	return card
	
func flip_top_card():
	get_top_card().open = true
	reorg_stack()

# Reposition cards so they are all visible
func reorg_stack():
	var child_count = get_child_count()
	if child_count <= 1:
		return
	
	var offset = Vector2(0, 0)
	
	var card = get_child(1)

	card.position = offset
	var previous_card_open = card.open

	# start at 1 to skip the Empty node
	for i in range(2, child_count):
		if previous_card_open:
			offset += Vector2(0, 30)
		else:
			offset += Vector2(0, 10)
			
		card = get_child(i)
		card.position = offset
		previous_card_open = card.open
