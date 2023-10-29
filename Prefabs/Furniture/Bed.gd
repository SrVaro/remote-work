extends StaticBody2D

@onready var interaction_area = $InteractionArea

var canSleep: bool = false
@onready var bed = $Bed

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_bed")
	
func toggle_lights():
	canSleep = !canSleep
	#if(!canSleep):
	#	bed.play("default")
	
func _trigger_bed():
	if canSleep:
		bed.play("bed_player")
		await GameSystem.sleep()
		bed.play("bed_empty")
		
