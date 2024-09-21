extends AnimatedSprite2D
var exploded = false
var the_direction = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = 1

func explode(player, x_position, y_position, direction):
	if not exploded:
		player.global_position.x = -1000
		the_direction = direction
		global_position.x = x_position
		global_position.y = y_position
		if direction == "top":
			rotation_degrees = 180
		elif direction == "bottom":
			rotation_degrees = 0
		elif direction == "left":
			rotation_degrees = 90
		elif direction == "right":
			rotation_degrees = -90
			
		if player.team_name == "team-one":
			play("explode")
		elif player.team_name == "team-two":
			play("purple_explode")
		elif player.team_name == "team-three":
			play("green_explode")
		elif player.team_name == "team-four":
			play("pink_explode")
		elif player.team_name == "blue-team":
			play("blue-explode")
		elif player.team_name == "red-team":
			play("red-explode")
			
func _on_animation_finished():
	queue_free()

