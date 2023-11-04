extends CanvasLayer

@onready var time_of_day = $HUD/MarginContainer/VBoxContainer3/HBoxClock/TimeOfDay

@onready var notification_list = $HUD/Window/WorkExeScreen/TextEditMargin/NotificationList

@onready var hud = $HUD
@onready var sleep_transition = $SleepTransition
@onready var day_description = $SleepTransition/VBoxContainer/DayDescription
@onready var day_of_the_week_label = $SleepTransition/VBoxContainer/DayOfTheWeekLabel

@onready var computer_desk = $HUD/Window/ComputerDesk
@onready var phone = $HUD/Phone

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

@onready var pause_margin = $HUD/PauseMargin

@onready var main_menu = $MainMenu

var transition_running: bool = false

var transition_state: float = 0
var alpha_objective: float = 0
var alpha_actual: float = 0

var following = false
var dragging_start_position = Vector2()

func _ready():
	Events.day_passed.connect(_day_passed)
	


func _process(_delta):
	if following:
		window.set_global_position(get_viewport().get_mouse_position())
	
func initialize_UI():
	#hud.hide()
	#pause_margin.hide()
	#work_exe_screen.hide()
	#icons.hide()
	#window.hide()
	pass
	
func start_game():
	toggle_main_menu()
	hud.show()
	_set_transition_text("")

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
		
func set_time(minutes: int, seconds: int):
	var day_format_string:String = "%02d:%02d" % [minutes, seconds]

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
	
func disable_main_menu():
	main_menu.get_node("Panel2/NewGame").disabled = !main_menu.get_node("Panel2/NewGame").disabled
	main_menu.get_node("Panel3/ExitGame").disabled = !main_menu.get_node("Panel3/ExitGame").disabled
	
func toggle_main_menu():
	main_menu.visible = !main_menu.visible

func _on_continue_button_pressed():
	toggle_pause_game(true)

func _on_exit_button_pressed():
	get_tree().quit()

func _on_new_game_pressed():
	GameSystem.start_game()
	
func show_phone():
	phone.play("phone_on")


func _on_title_bar_gui_input(event):
	print(event)
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_viewport().get_mouse_position()

func _on_CloseButton_pressed():
	get_tree().quit()
	
