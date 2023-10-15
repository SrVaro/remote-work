extends Node2D
class_name MainScene

@export var notification_manager: NotificationManager


var jobStatus: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if !notification_manager.is_connected("notification_timeout", _notification_timeout):
		notification_manager.connect("notification_timeout", _notification_timeout)
		

func _process(_delta):
	var time = Time.get_ticks_usec()
	var total_seconds: int

	if (time % 10) == 0:
		total_seconds = time / 1000000
		var seconds: int = fmod(total_seconds * 10 , 60.0)
		var minutes: int   =  fmod(int(total_seconds * 10 / 60.0) % 60, 24)
		UI._set_time(minutes, seconds)

	
	if (time % 450) == 0:
		notification_manager._add_notification_to_queue()
		
func _notification_timeout():
	jobStatus -= 10
	UI._set_job_status(jobStatus)
	pass


