extends CanvasLayer

@onready var time_of_day = $HUD/MarginContainer/VBoxContainer3/HBoxClock/TimeOfDay

@onready var notification_list = $HUD/Window/WorkExeScreen/TextEditMargin/NotificationList

@onready var hud = $HUD
func set_hud(isVisible: bool):
	hud.visible = isVisible
	
@onready var main_menu = $MainMenu
func set_main_menu(isVisible: bool):
	main_menu.visible = isVisible
	
@onready var sleep_transition = $SleepTransition
@onready var day_description = $SleepTransition/VBoxContainer/DayDescription
@onready var day_of_the_week_label = $SleepTransition/VBoxContainer/DayOfTheWeekLabel

@onready var computer_desk = $HUD/Window/ComputerDesk
@onready var phone_animation_player = $HUD/PhoneAnimationPlayer


@onready var job_status = $HUD/MarginContainer/VBoxContainer4/VBoxContainer/JobStatus
func set_job(value: int):
	job_status.value = value
func get_job():
	return job_status.value
	
@onready var health = $HUD/MarginContainer/VBoxContainer4/VBoxContainer/Health
func set_health(value: int):
	health.value = value
func get_health():
	return health.value
	
@onready var rest = $HUD/MarginContainer/VBoxContainer4/VBoxContainer/Rest
func set_rest(value: int):
	rest.value = value
func get_rest():
	return rest.value


@onready var icons = $HUD/Window/IconsMargin/Icons
@onready var work_exe_screen = $HUD/Window/WorkExeScreen
@onready var window = $HUD/Window

@onready var clock_hand_mins = $HUD/MarginContainer/VBoxContainer3/HBoxClock/ClockRect/ClockHandMins
@onready var clock_hand_hours = $HUD/MarginContainer/VBoxContainer3/HBoxClock/ClockRect/ClockHandHours


@onready var pause_margin = $PauseMargin
func set_pause_game(value: bool):
	pause_margin.visible = value
func get_pause_game():
	return pause_margin.visible
	
@onready var game_over_margin = $GameOverMargin
func set_game_over(value: bool):
	game_over_margin.visible = value

var transition_running: bool = false

var transition_state: float = 0
var alpha_objective: float = 0
var alpha_actual: float = 0

var following = false
var dragging_start_position = Vector2()

func _ready():
	Events.day_passed.connect(_day_passed)
	Events.tiktok_event.connect(_toggle_phone)

func _process(_delta):
	if following:
		window.set_global_position(get_viewport().get_mouse_position())
	
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
	
func _toggle_phone(value: bool):
	if value:
		phone_animation_player.play("phone_on")
	else: 
		phone_animation_player.play("phone_off")
	
func _set_transition_text(text: String):
	day_description.text = text
		
func fade_transition(type: String, wait_sec: float):
	transition_state = 0
	var transition_finished: bool = false
	var goal_alpha: float
	var actual_alpha: float
	
	if type == "fade_in":
		goal_alpha = 1
	elif type == "fade_out":
		goal_alpha = 0
		
	actual_alpha = sleep_transition.modulate.a
		
	while !transition_finished:
		sleep_transition.modulate.a =  lerp(actual_alpha, goal_alpha, transition_state)
			
		transition_state += 0.01
		
		await get_tree().create_timer(0.01).timeout
		
		if transition_state >= 1:
			transition_finished = true
			sleep_transition.modulate.a = goal_alpha
			
	await get_tree().create_timer(wait_sec).timeout
		
func set_time(hours: int, minutes: int):
	var day_format_string:String = "%02d:%02d" % [hours, minutes]
	clock_hand_hours.rotation_degrees = hours * 30
	clock_hand_mins.rotation_degrees = (minutes /10) * 60

	time_of_day.text = day_format_string
	
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

func _on_continue_button_pressed():
	GameSystem.toggle_pause_game()

func _on_new_game_button_pressed():
	GameSystem.reset_game()

func _on_computer_desk_animation_finished():
	icons.show()
	
func _on_work_exe_pressed():
	work_exe_screen.show()
	
func _on_window_close_requested():
	GameSystem.toggle_computer_mode()
	
func _on_exit_button_pressed():
	get_tree().quit()

func _on_new_game_pressed():
	main_menu.get_node("Panel2/NewGame").disabled = !main_menu.get_node("Panel2/NewGame").disabled
	main_menu.get_node("Panel3/ExitGame").disabled = !main_menu.get_node("Panel3/ExitGame").disabled
	GameSystem.reset_day()

func _on_title_bar_gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_viewport().get_mouse_position()

func _on_CloseButton_pressed():
	get_tree().quit()
	




