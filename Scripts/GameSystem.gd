extends Node2D


@onready var time_controller = get_node("/root/MainScene/TimeController")

var job_status: int = 100
var rest_status: int = 100
var health_status: int = 100

var computer_on: bool = false

var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	UI._sleep_transition(["fade_out"])
	
	Events.tick.connect(_on_tick)
	if !NotificationManager.is_connected("notification_timeout", _notification_timeout):
		NotificationManager.connect("notification_timeout", _notification_timeout)
		
	random.randomize()

func _on_tick(ticks: int):
	if ticks % random.randi_range(1, 1000) == 0:
		NotificationManager._add_notification_to_queue()

	if ticks % 3 == 0 && rest_status > 0:

		rest_status -= 3
		rest_status = clamp(rest_status, 0, 100)
		UI.set_rest(rest_status)
		
	if rest_status <= 0 && health_status > 0:
		health_status -= 5
		health_status = clamp(health_status, 0, 100)
		UI.set_health(health_status)

func _notification_timeout():
	job_status -= 10
	UI.set_job_status(job_status)
	pass

func sleep():
	time_controller.reset_day()
	UI._sleep_transition(["fade_in", "fade_out"])
	_set_rest_status(100)
	pass

func _set_rest_status(value: int):
	rest_status = rest_status + value
	UI.set_rest(rest_status)
	
func toggle_computer_mode():
	computer_on = !computer_on
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	UI.computer_toggle()
	
func is_computer_mode_on() -> bool:
	return computer_on
		
	
	
