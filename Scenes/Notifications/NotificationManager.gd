extends Node2D

signal add_notification(notification)
signal remove_first_notification()
signal remove_last_notification()


var notificationList = []

var notification_scene = preload("res://Scenes/Notifications/Notification.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _add_notification_to_queue():
	var notification_instance = notification_scene.instantiate()
	notification_instance.connect("notification_timeout_expired", _notification_timeout_expired)
	notificationList.append(notification_instance)
	UI._add_notification(notification_instance)
	
func _remove_last_notification() -> void:
	if notificationList.size() != 0:
		notificationList.remove_at(notificationList.size()-1)
		UI._remove_last_notification()
		
func _remove_first_notification() -> void:
	if notificationList.size() != 0:
		notificationList.remove_at(0)
		UI._remove_first_notification()
		
func _is_notification_list_empty():
	return notificationList.size() == 0
	
func _notification_timeout_expired() -> void:
	_remove_first_notification()
	GameSystem.job_status -= 10
	
	

