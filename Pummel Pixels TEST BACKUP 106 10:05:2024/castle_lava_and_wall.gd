extends Node2D

@onready var wall = $TileMap
@onready var lava = $Lava

var max_y = 310
var direction = -.05
var stopped = false
var shake_frames = 0
var wall_direction = 1

func _ready():
	lava.global_position.y = 1380

func _process(_delta):
	if not stopped:
		if lava.global_position.y > max_y + 20:
			direction = -.01
		else:
			stopped = true
			shake_frames = 0
			direction = 0
		lava.global_position.y += direction
	else:
		if shake_frames <= 800:
			wall.global_position.x += wall_direction
			if shake_frames % 10 == 0:
				wall_direction *= -1
			shake_frames += 1
		
	if shake_frames > 800:
		wall.global_position.y += .25

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("take_damage"):
			body.take_damage(-500, -50000, 35)
			
func _on_area_2d_2_body_entered(body):
	if body is CharacterBody2D:
		if body.has_method("take_damage"):
			body.take_damage(500, -50000, 35)
