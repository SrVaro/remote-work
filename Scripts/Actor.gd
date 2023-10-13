extends CharacterBody2D
class_name Actor

@export
var speed: = Vector2(300.0, 300.0)

var vel: = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	move_and_slide()
	

