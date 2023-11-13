extends Node2D

@onready var door = $"../Door/Door"
@onready var door_collision = $"../Door/DoorCollision"
@onready var spawn_point = $"../SpawnPoint"

var level: int = 0

func reset_levels():
	level = 0

func load_next_level():
	level += 1
	
	if level == 1:
		UI._set_transition_text("Lunes por la mañana despues de un domingo de fiesta... 
			Solo tengo que aguantar el tipo hastalas 18:00 para poder meterme en la cama de nuevo y pasar la resaca...")
	elif level == 2:
		UI._set_transition_text("He sobrevivido a la resaca de ayer.. 
			aunque no he conseguido dormir bien en toda la noche. Nada que no solucione uno o dos cafes")
		GameSystem.rest_status = 25
		door.play("door_opened")
		door_collision.disabled = true
	elif level == 3:
		UI._set_transition_text("Mitad de semana, ya estoy al 100%
			puedo relajarme un poquito, espero que no haya ningun problema hasta el viernes")
		GameSystem.tiktok_event_available = true
		GameSystem.rest_status = 100
	elif level == 4:
		UI._set_transition_text("WE ARE SO BACK")
		GameSystem.tiktok_event_available = false
		GameSystem.task_max_range = 2
		GameSystem.rest_status = 100
		
func get_actual_level_spawn() -> Vector2:
	return spawn_point.global_position


