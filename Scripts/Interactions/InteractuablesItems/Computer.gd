extends Node2D

@onready var interaction_area = $InteractionArea
@onready var progressBar = $ProgressBar
@onready var particleSystem = $GPUParticles2D
@onready var computer = $Computer


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_computer")
	
func _trigger_computer():
	GameSystem.toggle_computer_mode()
	if !NotificationManager._is_notification_list_empty():
		if progressBar.value < 100:
			computer.play("new_animation")
			progressBar.value += 2.5
			particleSystem.show()
			particleSystem.speed_scale = progressBar.value / 40
		else:
			NotificationManager._remove_last_notification()
			progressBar.value = 0
			particleSystem.hide()
			computer.play("default")
	

	
