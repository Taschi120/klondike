extends Node2D

class_name CardStack

@export var type = Regions.DRAW

var hovered = false

var tween: Tween = null

func _ready() -> void:
	if $DropoffSpot:
		$DropoffSpot.mouse_entered.connect(func(): hovered = true)
		$DropoffSpot.mouse_exited.connect(func(): hovered = false)

func get_cards() -> Array:
	return $Internal.get_children()
	
func add_card(_card):
	$Internal.add_child(_card)
	reposition_card(_card)
	
func reposition_card(_card: Card) -> void:
	tween = _card.create_tween_and_kill_previous()
	tween.tween_property(_card, "position", Vector2.ZERO, 0.1)
	
func add_cards(stack: Array) -> void:
	for card in stack:
		add_card(card)
	
func remove_card(_card):
	$Internal.remove_child(_card)
	
func is_empty():
	return $Internal.get_child_count() == 0
	
func size():
	return $Internal.get_child_count()
	
func peek():
	var child_count = $Internal.get_child_count()
	assert(child_count > 0)
	return $Internal.get_child(child_count - 1)
	
func take_top_card():
	var child_count = $Internal.get_child_count()
	assert(child_count > 0)
	var result = $Internal.get_child(child_count - 1)
	$Internal.remove_child(result)
	return result
		
func get_region():
	assert(false) # needs to be overridden in every implementation

func contains(_card) -> bool:
	return $Internal.get_children().has(_card)
	
func _on_selection_changed(selection: Array, source: CardStack) -> void:
	if selection.is_empty():
		$DropoffSpot.active = false
	else:
		$DropoffSpot.active = can_accept(selection, source)
	
func can_accept(cards: Array, source: CardStack) -> bool:
	return false
	


func _on_dropoff_spot_mouse_entered() -> void:
	hovered = true

func _on_dropoff_spot_mouse_exited() -> void:
	hovered = false
