extends Node2D
class_name MainScene

@export var notification_manager: NotificationManager
@export var ui: UI

# Called when the node enters the scene tree for the first time.
func _ready():
	if !notification_manager.is_connected("notification", ui._add_notification):
		notification_manager.connect("notification", ui._add_notification)
		
	if !notification_manager.is_connected("remove_notification", ui._remove_last_notification):
		notification_manager.connect("remove_notification", ui._remove_last_notification)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

