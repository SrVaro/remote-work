extends Actor


var input_direction: get = _get_input_direction
var sprite_direction = "Down": get = _get_sprite_direction

@onready var sprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity = input_direction * speed
	set_animation("Walk")
	if velocity == Vector2.ZERO:
		sprite.stop()
	
func set_animation(animation):
	var direction = "Side" if sprite_direction in ["Left", "Right"] else sprite_direction
	sprite.play(animation + direction)
	sprite.flip_h = (sprite_direction == "Left")
	
func _get_input_direction():
	if !GameSystem.is_computer_mode_on():
		return Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))
	else:
		return Vector2(0, 0)
		
func _get_sprite_direction():
	match input_direction:
		Vector2.LEFT:
			sprite_direction = "Left"
		Vector2.RIGHT:
			sprite_direction = "Right"
		Vector2.UP:
			sprite_direction = "Up"
		Vector2.DOWN:
			sprite_direction = "Down"
	return sprite_direction
