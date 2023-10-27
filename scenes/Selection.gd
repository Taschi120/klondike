extends CardStack

class_name Selection

var source: CardStack = null

func add_card(card):
	assert(source != null) # whoever calls this MUST ensure source is set first - otherwise, application state
	# will go to shit! Ideally, call add_card_from(...) instead
	super.add_card(card)
	card.position = Vector2.ZERO
	card.at_top = false
	
func add_card_from(card: Card, _source: CardStack) -> void:
	assert(is_empty())
	assert(_source != null)
	assert(card != null)
	source = _source
	add_card(card)
	

func add_cards_from(stack: Array, _source: CardStack) -> void:
	assert(is_empty())
	assert(_source != null)
	assert(stack.size() != null)
	source = _source
	for card in stack:
		add_card(card)

func take_cards() -> Array:
	assert($Internal.get_child_count() > 0)
	var children = $Internal.get_children()
	var result = Array(children)
	for child in children:
		$Internal.remove_child(child)
		
	assert(is_empty())
	source = null
	return result
	
func put_back() -> void:
	assert($Internal.get_child_count() > 0)
	assert(source != null)
	# we need to "buffer" the source because take_cards() will null it
	var _source = source
	var cards = take_cards()
	_source.add_cards(cards)

func get_region():
	return Regions.CURSOR
	
func _process(delta: float) -> void:
	position = get_global_mouse_position()
