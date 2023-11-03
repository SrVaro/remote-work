extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var bed = $Bed

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_bed")
	
func toggle_lights():
	interaction_area.available = !interaction_area.available
	bed.play("bed_empty")
	
func _trigger_bed():
	if interaction_area.available:
		bed.play("bed_player")
		await GameSystem.sleep()
		bed.play("bed_empty")
