extends Node2D

@onready var interaction_area = $InteractionArea

signal coffee_drinked()

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_coffe")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _trigger_coffe():
	print("Coffee drinked")
	coffee_drinked.emit()
	
