extends NinePatchRect

@onready var timer = $Timer
@onready var timeout_progress_bar = $TimeoutProgressBar

signal notification_timeout_expired()

func _process(_delta):
	timeout_progress_bar.value = 100 - (timer.time_left / timer.wait_time * 100)


func _on_timer_timeout():
	notification_timeout_expired.emit()
