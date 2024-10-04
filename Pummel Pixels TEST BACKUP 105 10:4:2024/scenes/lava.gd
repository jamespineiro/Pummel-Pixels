extends CharacterBody2D
@onready var main = get_tree().get_root()

var max_y = 320
var min_y = 370
var direction = -.05
var stop_at_top = false
var stopped = false

func _ready():
	global_position.y = 370

func _process(_delta):
	if not stopped:
		if global_position.y > min_y:
			direction = -.05
		elif global_position.y < max_y:
			if stop_at_top == true: 
				stopped = true
			direction = .050
	global_position.y += direction

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("take_damage"):
			body.take_damage(500, -50000, 35)
			
func _on_area_2d_2_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("take_damage"):
			body.take_damage(-500, -50000, 35)
