extends Node2D

@onready var tick_timer = $TickTimer

var ticks: int = 48

func _on_tick_timer_timeout():
	ticks += 1
	Events.tick.emit(ticks)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
