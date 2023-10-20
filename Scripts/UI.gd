extends CanvasLayer

@onready var time_of_day = $Control/MarginContainer/VBoxContainer3/HBoxClock/TimeOfDay

@onready var notification_list = $Control/MarginContainer/NotificationList

@onready var sleep_transition = $Control/SleepTransition

@onready var animated_sprite_2d = $Control/ComputerUIMargin/Control/AnimatedSprite2D

@onready var job_status = $Control/MarginContainer/VBoxContainer3/VBoxContainer/JobStatus
@onready var health = $Control/MarginContainer/VBoxContainer3/VBoxContainer/Health
@onready var rest = $Control/MarginContainer/VBoxContainer3/VBoxContainer/Rest

var transition_running: bool = false

var transition_state: float = 0
var alpha_objective: float = 0
var alpha_actual: float = 0

func _process(_delta):
	if transition_running:
		sleep_transition.color.a =  lerp(alpha_actual, alpha_objective, transition_state)
		transition_state += 0.01

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
		
func _sleep_transition(types):
	for type in types:
		transition_running = true
		transition_state = 0
		
		if (type == "fade_in"):
			alpha_objective = 1
			alpha_actual = 0

		if type == "fade_out":
			alpha_objective = 0
			alpha_actual = 1

		await get_tree().create_timer(1.0).timeout
		transition_running = false
		
		
	
func set_time(minutes: int, seconds: int):
	var day_format_string:String = "%02d:%02d" % [minutes, seconds]

	time_of_day.text = day_format_string
	
func set_health(health_value: int):
	health.value = health_value
	
func set_job_status(job_status_value: int):
	job_status.value = job_status_value
	
func set_rest(rest_value: int):
	rest.value = rest_value
	
func computer_toggle():
	animated_sprite_2d.stop()
	animated_sprite_2d.visible = !animated_sprite_2d.visible
	animated_sprite_2d.play("default")
	

	

