extends Node2D

@onready var door = $"../Door/Door"
@onready var door_collision = $"../Door/DoorCollision"

var level: int = 1

func _ready():
	pass # Replace with function body.
	

func load_next_level():
	level += 1
	
	if level == 2:
		door.play("door_opened")
		door_collision.disabled = true
		GameSystem.rest_status = 50


