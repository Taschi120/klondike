extends Node2D

var Constants = preload("res://scripts/constants.gd")

@onready var tableau = [
	$Tableaux/TableauPile1,
	$Tableaux/TableauPile2,
	$Tableaux/TableauPile3,
	$Tableaux/TableauPile4,
	$Tableaux/TableauPile5,
	$Tableaux/TableauPile6,
	$Tableaux/TableauPile7,
]

func _ready() -> void:
	$StockAndDiscard.create_and_shuffle()
	
	# put cards on tableauc
	for tableau_num in range(7):
		var stack = tableau[tableau_num]
		# deal n face-down cards
		for card_num in range(tableau_num):
			var card = $StockAndDiscard.draw_and_remove()
			card.location = Constants.Location.TABLEAU
			stack.add_card(card)
		# and deal one face-open card
		var card = $StockAndDiscard.draw_and_remove()
		card.open = true
		card.at_top = true
		card.location = Constants.Location.TABLEAU
		stack.add_card(card)

func _on_card_clicked(_card) -> void:
	print(_card.debug_string())
	
	match _card.location:
		Constants.Location.DRAW:
			var card = $StockAndDiscard.draw_and_remove()
			$StockAndDiscard.add_to_discard(card)
	
