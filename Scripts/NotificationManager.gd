extends Node2D
class_name NotificationManager

signal notification(notification)
signal remove_notification()

var notificationList = []

var notification_scene = preload("res://Prefabs/Notification.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_ticks_usec()
	if (time % 450) == 0:
		_add_notification_to_queue()

func _add_notification_to_queue():
	var notification_instance = notification_scene.instantiate()
	notificationList.append(notification_instance)
	notification.emit(notification_instance)
	pass
	
func _remove_last_notification() -> void:
	if notificationList.size() != 0:
		notificationList.remove_at(notificationList.size()-1)
		remove_notification.emit()
		
func _is_notification_list_empty():
	return notificationList.size() == 0
	

