extends Node2D

@onready var time_controller = $TimeController
@onready var player = get_node("/root/MainScene/Player")
@onready var level_manager = get_node("/root/MainScene/House/LevelManager")
@onready var main_menu = $MainMenu

var job_status: int = 100:
	get:
		return job_status
	set(value):
		job_status = value
		UI.set_job(job_status)
var rest_status: int = 100:
	get:
		return rest_status
	set(value):
		rest_status = value
		UI.set_rest(rest_status)
var health_status: int = 100:
	get:
		return health_status
	set(value):
		health_status = value
		UI.set_health(health_status)

var computer_on: bool = false
var job_on: bool = true

var random = RandomNumberGenerator.new()

func _ready():
	get_tree().paused = true
	Events.tick.connect(_on_tick)
	random.randomize()

func start_game():
	UI.disable_main_menu()
	await UI.fade_transition("fade_in", 2.5)
	UI.toggle_main_menu()
	UI.get_node("HUD").show()
	UI._set_transition_text("")
	time_controller.reset_lights()
	main_menu.enabled = false
	player.show()
	player.get_node("PlayerCamera").enabled = true
	await UI.fade_transition("fade_out", 0)
	get_tree().paused = false


func _on_tick(ticks: int):
	if ticks % random.randi_range(1, 65) == 0:
		NotificationManager._add_notification_to_queue()

	if ticks % 3 == 0 && rest_status > 0 && job_on:
		rest_status = clamp(rest_status - 3, 0, 100)

	if rest_status <= 0 && health_status > 0:
		health_status = clamp(health_status - 5, 0, 100)

func sleep():
	player.hide()
	await UI.fade_transition("fade_in", 2)
	_load_next_level()
	await UI.fade_transition("fade_out", 0)
	
func _load_next_level():
	time_controller.reset_lights()
	level_manager.load_next_level()
	player.show()

func job_ended():
	job_on = false
	
func toggle_computer_mode():
	computer_on = !computer_on
	UI.computer_toggle(computer_on)
	
func is_computer_mode_on() -> bool:
	return computer_on
	
		
	
	
