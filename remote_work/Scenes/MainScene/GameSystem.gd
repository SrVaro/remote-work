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
		

var tiktok_running: bool = false

# Variables that manage difficulty
var tiktok_event_available: bool = false
var task_min_range: int = 1
var task_max_range: int = 1

var game_started: bool = false
var computer_on: bool = false
var job_on: bool = true

var random = RandomNumberGenerator.new()

func _ready():
	get_tree().paused = true
	Events.tick.connect(_on_tick)
	Events.tiktok_event.connect(_on_ticktock_event)
	random.randomize()
	
func _input(event):
	if event.is_action_pressed("pause_menu") && game_started:
		toggle_pause_game()

func reset_day():
	get_tree().paused = true
	level_manager.load_next_level()
	await UI.fade_transition("fade_in", 2.5)
	exit_main_menu()
	await UI.fade_transition("fade_out", 0)
	get_tree().paused = false
	game_started = true
	
func reset_game():
	time_controller.reset_time()
	level_manager.reset_levels()
	level_manager.load_next_level()
	game_started = false
	await UI.fade_transition("fade_in", 2.5)
	UI.set_game_over(false)
	time_controller.reset_lights()
	player.global_position = level_manager.get_actual_level_spawn()
	await UI.fade_transition("fade_out", 0)
	get_tree().paused = false
	game_started = true
	
func exit_main_menu():
	UI.set_main_menu(false)
	UI.set_hud(true)
	main_menu.enabled = false
	time_controller.reset_lights()
	player.global_position = level_manager.get_actual_level_spawn()
	player.get_node("PlayerCamera").enabled = true
	player.show()

func _on_tick(ticks: int):
	if ticks % random.randi_range(1, 65) == 0 && job_on:
		NotificationManager._add_notification_to_queue(random.randi_range(task_min_range, task_max_range))

	if ticks % 3 == 0 && rest_status > 0:
		rest_status = clamp(rest_status - 3, 0, 100)

	if rest_status <= 0 && health_status > 0:
		health_status = clamp(health_status - 5, 0, 100)
		
	if ticks % random.randi_range(1, 100) == 0 && !tiktok_running && tiktok_event_available:
		Events.tiktok_event.emit(true)
		
	if job_status <= 0 || health_status <= 0:
		get_tree().paused = true
		UI.set_game_over(true)
	

func toggle_pause_game():
	UI.set_pause_game(!UI.get_pause_game())
	get_tree().paused = !get_tree().paused

func _on_ticktock_event(value: bool):
	tiktok_running = value
	pass

func sleep():
	player.hide()
	reset_day()

func job_ended():
	job_on = false
	
func toggle_computer_mode():
	computer_on = !computer_on
	UI.computer_toggle(computer_on)
	
func is_computer_mode_on() -> bool:
	return computer_on
	
		
	
	
