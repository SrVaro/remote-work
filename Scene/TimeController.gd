extends Node2D

@onready var canvas_modulate = $CanvasModulate

var minutes: int = 0
var hours: int = 8

const days_of_week_enum = ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"]
var day_of_week = 0

var night_mode: bool = false

var lightning_level: float = 255

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.tick.connect(_on_tick)
	##UI.set_time(fmod(int(ticks * 10 / 60.0) % 60, 24), fmod(ticks * 10 , 60.0))

func _on_tick(ticks: int):
	
	minutes += 10
	
	if minutes % 60 == 0:
		hours += 1
		minutes = 0
	
	if hours % 24 == 0:
		hours = 0
	
	lightning_level -= 1
	var lightColor: float = lightning_level / 255
	canvas_modulate.color = Color(lightColor, lightColor, lightColor, 1)
	
	UI.set_time(hours, minutes)
	
	if (hours > 20 || hours < 8) && !night_mode:
		night_mode = true
		get_tree().call_group("Lights","toggle_lights")
		day_passed()
		
	if (hours >= 8 && hours <= 20) && night_mode:
		night_mode = false
		get_tree().call_group("Lights","toggle_lights")
		
func day_passed():
	day_of_week += 1
	Events.day_passed.emit(days_of_week_enum[day_of_week])
	
func reset_day():
	lightning_level = 255
	minutes = 0
	hours = 8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
