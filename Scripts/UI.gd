extends CanvasLayer
class_name UI

@onready var v_box_container = $Control/MarginContainer/VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _add_notification(notification) -> void:
	if(notification):
		v_box_container.add_child(notification)

func _remove_last_notification() -> void:
	var notifications = v_box_container.get_children(false)
	if notifications.size() != 0:
		notifications[notifications.size() - 1].queue_free()

