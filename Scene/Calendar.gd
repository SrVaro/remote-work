extends Sprite2D

@onready var calendar_label = $CalendarLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.day_passed.connect(_day_passed)
	pass # Replace with function body.

func _day_passed(value: String):
	calendar_label.text = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
