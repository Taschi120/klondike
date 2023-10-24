extends CardStack

class_name TableauPile

func add_card(_card):
	super.add_card(_card)
	reorg_stack()
	
func remove_card(_card):
	super.remove_card(_card)
	reorg_stack()
	
func take_top_card():
	var result = super.take_top_card()
	reorg_stack()
	return result

# Reposition cards so they are all visible
func reorg_stack():
	var child_count = size()
	if is_empty():
		return
	
	var offset = Vector2(0, 0)
	
	var card = $Internal.get_child(0)

	card.position = offset
	var previous_card_open = card.open

	for i in range(0, child_count):
		if previous_card_open:
			offset += Vector2(0, 40)
		else:
			offset += Vector2(0, 10)
			
		card = $Internal.get_child(i)
		card.position = offset
		previous_card_open = card.open
		
func get_region():
	return Regions.TABLEAU
