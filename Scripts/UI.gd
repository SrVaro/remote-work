extends CanvasLayer

@onready var time_of_day = $Control/MarginContainer/VBoxContainer3/HBoxClock/TimeOfDay

@onready var notification_list = $Control/Window/ComputerDesk/WorkExeScreen/NotificationList

@onready var sleep_transition = $Control/SleepTransition
@onready var day_of_the_week_label = $Control/SleepTransition/DayOfTheWeekLabel

@onready var computer_desk = $Control/Window/ComputerDesk

@onready var job_status = $Control/MarginContainer/VBoxContainer4/VBoxContainer/JobStatus
@onready var health = $Control/MarginContainer/VBoxContainer4/VBoxContainer/Health
@onready var rest = $Control/MarginContainer/VBoxContainer4/VBoxContainer/Rest

@onready var icons = $Control/Window/ComputerDesk/Icons
@onready var work_exe_screen = $Control/Window/ComputerDesk/WorkExeScreen
@onready var window = $Control/Window

@onready var pause_margin = $Control/PauseMargin

@onready var main_menu = $MainMenu

var transition_running: bool = false

var transition_state: float = 0
var alpha_objective: float = 0
var alpha_actual: float = 0

func _ready():
	Events.day_passed.connect(_day_passed)

func _process(_delta):
	if transition_running:
		sleep_transition.color.a =  lerp(alpha_actual, alpha_objective, transition_state)
		day_of_the_week_label.modulate.a  =  lerp(alpha_actual, alpha_objective, transition_state)
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
		
func _day_passed(value: String):
	day_of_the_week_label.text = value
		
func _sleep_transition(types):
	for type in types:
		transition_running = true
		transition_state = 0
		
		if type == "fade_in":
			alpha_objective = 1
			alpha_actual = 0

		if type == "fade_out":
			alpha_objective = 0
			alpha_actual = 1

		await get_tree().create_timer(1.75).timeout
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
	
func computer_toggle(computer_on: bool):
	window.visible = computer_on
	if computer_on:
		computer_desk.stop()
		work_exe_screen.hide()
		computer_desk.play("default")
	else: 
		window.hide()
		work_exe_screen.hide()
		icons.hide()

func _on_computer_desk_animation_finished():
	icons.show()
	
func _on_work_exe_pressed():
	work_exe_screen.show()
	
func _on_window_close_requested():
	GameSystem.toggle_computer_mode()
	
func toggle_pause_game(with_menu: bool):
	get_tree().paused = !get_tree().paused
	if with_menu:
		pause_margin.visible = !pause_margin.visible

func _input(event):
	if event.is_action_pressed("pause_menu"):
		toggle_pause_game(true)
	
func toggle_main_menu():
	main_menu.visible = !main_menu.visible

func _on_continue_button_pressed():
	toggle_pause_game(true)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_new_game_pressed():
	GameSystem.start_game()

