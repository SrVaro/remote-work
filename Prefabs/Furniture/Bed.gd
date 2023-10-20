extends StaticBody2D

@onready var interaction_area = $InteractionArea

var canSleep: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_bed")
	
func toggle_lights():
	canSleep = !canSleep
	
func _trigger_bed():
	if canSleep:
		GameSystem.sleep()
		canSleep = false
		
