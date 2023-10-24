extends Node2D

# Reposition cards so they are all visible
func reorg_stack():
	var child_count = $CardStack.get_child_count()
	if $CardStack.is_empty():
		return
	
	var offset = Vector2(0, 0)
	
	var card = $CardStack.get_child(0)

	card.position = offset
	var previous_card_open = card.open

	for i in range(0, child_count):
		if previous_card_open:
			offset += Vector2(0, 40)
		else:
			offset += Vector2(0, 10)
			
		card = get_child(i)
		card.position = offset
		previous_card_open = card.open
