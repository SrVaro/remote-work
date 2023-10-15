extends CanvasLayer

@onready var time_of_day = $Control/MarginContainer/VBoxContainer2/TimeOfDay
@onready var job_status = $Control/MarginContainer/VBoxContainer3/HBoxContainer2/JobStatus
@onready var health = $Control/MarginContainer/VBoxContainer3/HBoxContainer/Health
@onready var rest = $Control/MarginContainer/VBoxContainer3/HBoxContainer/Rest
@onready var notification_list = $Control/MarginContainer/NotificationList



func _add_notification(notification) -> void:
	if(notification):
		notification_list.add_child(notification)

func _remove_last_notification() -> void:
	var notifications = notification_list.get_children(false)
	if notifications.size() != 0:
		notifications[notifications.size() - 1].queue_free()
	
func _remove_first_notification() -> void:
	var notifications = notification_list.get_children(false)
	if notifications.size() != 0:
		notifications[0].queue_free()
		
func _set_time(minutes: int, seconds: int):
	var day_format_string:String = "%02d:%02d" % [minutes, seconds]

	time_of_day.text = day_format_string
	
func _set_health(health_value: int):
	health.value = health_value
	
func _set_job_status(job_status_value: int):
	job_status.value = job_status_value
	
func _set_rest(rest_value: int):
	rest.value = rest_value
	

