extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var progressBar = $ProgressBar
@onready var particleSystem = $GPUParticles2D
@onready var notification_manager = $"../NotificationManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_computer")
	
func _trigger_computer():
	if !notification_manager._is_notification_list_empty():
		if progressBar.value < 100:
			progressBar.value += 2.5
			particleSystem.show()
			particleSystem.speed_scale = progressBar.value / 40
		else:
			_work_done()
			particleSystem.hide()
		
func _work_done():
	notification_manager._remove_last_notification()
	progressBar.value = 0

	
