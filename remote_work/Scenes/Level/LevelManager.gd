extends Node2D

@onready var door = $"../Door/Door"
@onready var door_collision = $"../Door/DoorCollision"
@onready var spawn_point = $"../SpawnPoint"

@onready var coffe_tutorial = $"../Tutorials/CoffeTutorial"
@onready var work_tutorial = $"../Tutorials/WorkTutorial"
@onready var movement_tutorial = $"../Tutorials/MovementTutorial"
@onready var tik_tok_tutorial = $"../Tutorials/TikTokTutorial"
@onready var work_tutorial_2 = $"../Tutorials/WorkTutorial2"
@onready var job_finish_tutorial = $"../Tutorials/JobFinishTutorial"

var level: int = 0

func reset_levels():
	level = 0

	
func load_next_level():
	level += 1
	
	if level == 1:
		UI._set_transition_text("Lunes por la mañana despues de un domingo de fiesta... 
			Solo tengo que aguantar el tipo hastalas 18:00 para poder meterme en la cama de nuevo y pasar la resaca...
			🤮")
		GameSystem.rest_status = 100
		GameSystem.job_status = 100
		GameSystem.health_status = 100
		movement_tutorial.show()
		work_tutorial.show()
		job_finish_tutorial.show()
	elif level == 2:
		UI._set_transition_text("He sobrevivido a la resaca de ayer.. 
			aunque no he conseguido dormir bien en toda la noche. Nada que no solucione uno o dos cafes")
		movement_tutorial.hide()
		work_tutorial.hide()
		job_finish_tutorial.hide()
		coffe_tutorial.show()
		GameSystem.rest_status = 25
		door.play("door_opened")
		door_collision.disabled = true
	elif level == 3:
		UI._set_transition_text("Mitad de semana, ya estoy al 100%
			puedo relajarme un poquito, espero que no haya ningun problema hasta el viernes")
		coffe_tutorial.hide()
		tik_tok_tutorial.show()
		GameSystem.tiktok_event_available = true
		GameSystem.rest_status = 100
	elif level == 4:
		tik_tok_tutorial.hide()
		work_tutorial_2.show()
		UI._set_transition_text("Ultimo dia, menos mal que los viernes no trabajo!")
		GameSystem.tiktok_event_available = false
		GameSystem.task_max_range = 2
		GameSystem.rest_status = 100
	elif level == 5:
		get_tree().paused = true
		UI.set_game_over(true)
		
func get_actual_level_spawn() -> Vector2:
	return spawn_point.global_position


