extends Node2D

@onready var light: AnimatedSprite2D = get_node("NightLight")

func toggle_lights():
	light.visible = !light.visible
