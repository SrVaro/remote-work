extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var panel = $Panel

const base_text = "Pulsa [E] para "

var active_areas = []
var can_interact = true

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active_areas.size() > 0 && can_interact && active_areas[0].available:
		active_areas.sort_custom(_sort_by_distance_to_player)
		if active_areas[0].action_name == "any_button":
			panel.get_node("Label").text = "¡Pulsa cualquier boton del teclado!"
		else:
			panel.get_node("Label").text = base_text + "interectuar"
			
		panel.global_position = active_areas[0].global_position
		panel.global_position.y -= 36
		panel.global_position.x -= panel.size.x / 2
		panel.show()
	else:
		panel.hide()
		

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if active_areas.size() > 0 && event.is_action_pressed(active_areas[0].action_name) && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			panel.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
			
			
