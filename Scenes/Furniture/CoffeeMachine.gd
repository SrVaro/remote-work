extends Node2D

@onready var coffee_machine_interaction_area = $CoffeeMachineInteractionArea

@onready var coffee = $Coffee
@onready var coffee_machine = $CoffeeMachine
@onready var coffee_timer = $CoffeeTimer
@onready var coffee_spawn_1 = $Coffees/CoffeeSpawn1
@onready var coffee_spawn_2 = $Coffees/CoffeeSpawn2
@onready var coffee_spawn_3 = $Coffees/CoffeeSpawn3

var coffeePrefab = preload("res://Scenes/Furniture/Coffee.tscn")

var coffeeList = []
var spawnPoints

@export var restPerCoffee: float

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPoints = [coffee_spawn_1, coffee_spawn_2, coffee_spawn_3]
	coffee_machine_interaction_area.interact = Callable(self, "_trigger_coffe_machine")
	
func _trigger_coffe_machine():
	if(coffeeList.size() < 3):
		coffee.show()
		coffee_machine.play("working")
		coffee_timer.start()
		
func _coffe_drinked():
	if(coffeeList.size() > 0):
		coffeeList[coffeeList.size()-1].queue_free()
		coffeeList.remove_at(coffeeList.size()-1)
		GameSystem.rest_status += 20

func _on_coffee_timer_timeout():
	coffee.hide()
	var coffee_instance = coffeePrefab.instantiate()
	self.add_child(coffee_instance)
	coffee_instance.connect("coffee_drinked", _coffe_drinked)
	coffee_instance.position = spawnPoints[coffeeList.size()].position
	coffeeList.append(coffee_instance)
	coffee_machine.play("default")
	


