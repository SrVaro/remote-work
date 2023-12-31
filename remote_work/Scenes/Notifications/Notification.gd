extends TextureRect
class_name Notification

@onready var timer = $Timer
@onready var timeout_progress_bar = $TimeoutProgressBar
@onready var story_points = $MarginContainer/StoryPoints

var task_level: int = 0

signal notification_timeout_expired()

func _ready():
	story_points.text = "STORY POINTS: " + str(task_level)

func _process(_delta):
	timeout_progress_bar.value = 100 - (timer.time_left / timer.wait_time * 100)


func _on_timer_timeout():
	notification_timeout_expired.emit()
