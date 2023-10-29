extends Node2D

class_name DropoffSpot

const COLOR_OFF = Color(Color.YELLOW, 0)
const COLOR_ON = Color(Color.YELLOW, 0.3)

var active = false : set = set_active

var hovered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.modulate = COLOR_OFF

func set_active(value: bool) -> void:
	active = value
	if active:
		$Sprite2D.modulate = COLOR_ON
	else:
		$Sprite2D.modulate = COLOR_OFF
